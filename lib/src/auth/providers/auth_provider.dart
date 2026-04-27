import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final String? userRole;
  final bool isCheckingAuth;

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.userRole,
    this.isCheckingAuth = true,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    String? userRole,
    bool? isCheckingAuth,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      userRole: userRole ?? this.userRole,
      isCheckingAuth: isCheckingAuth ?? this.isCheckingAuth,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthNotifier() : super(AuthState()) {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) async {
      
      if (user != null) {
        state = state.copyWith(isCheckingAuth: true);
        await _fetchUserRole(user.uid);
        state = state.copyWith(user: user, isCheckingAuth: false);
        
      } else {
        state = state.copyWith(user: null, userRole: null, isCheckingAuth: false);
        
      }
    });
  }

  Future<void> _fetchUserRole(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
          
      if (doc.exists) {
        final userRole = doc.data()?['userType'] as String?;
        state = state.copyWith(userRole: userRole);
        
      } else {
        
        // Create the document if it doesn't exist
        await _createUserDocument(userId);
      }
    } catch (e) {
      
    }
  }

  Future<void> _createUserDocument(String userId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(userId).set({
          'email': user.email,
          'userType': 'student',
          'createdAt': FieldValue.serverTimestamp(),
          'totalBalance': 0.0,
          'income': 0.0,
          'expenses': 0.0,
        });
        state = state.copyWith(userRole: 'student');
        
      }
    } catch (e) {
      
    }
  }

  Future<bool> registerWithEmail(String email, String password, String userType) async {
    
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Save user role to Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'userType': userType,
        'createdAt': FieldValue.serverTimestamp(),
        'totalBalance': 0.0,
        'income': 0.0,
        'expenses': 0.0,
      });
      
      state = state.copyWith(
        user: result.user,
        userRole: userType,
        isLoading: false,
        errorMessage: null,
      );
      
      return true;
      
    } on FirebaseAuthException catch (e) {
      
      state = state.copyWith(
        errorMessage: _getErrorMessage(e),
        isLoading: false,
      );
      return false;
    } catch (e) {
      
      state = state.copyWith(
        errorMessage: 'An error occurred',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Fetch user role
      await _fetchUserRole(result.user!.uid);
      state = state.copyWith(
        user: result.user,
        isLoading: false,
        errorMessage: null,
      );
      
      return true;
      
    } on FirebaseAuthException catch (e) {
      
      state = state.copyWith(
        errorMessage: _getErrorMessage(e),
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        errorMessage: _getErrorMessage(e),
        isLoading: false,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    state = AuthState();
  }

  Future<void> updateUserRole(String role) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'userType': role,
      });
      state = state.copyWith(userRole: role);
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak (min 6 characters)';
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return e.message ?? 'Authentication failed';
    }
  }
}