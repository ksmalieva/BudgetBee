import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/screens/welcome_screen.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/register_screen.dart';
import '../auth/screens/forgot_password_screen.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../transactions/screens/transactions_screen.dart';
import '../auth/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Wait for auth check to complete
      if (authState.isCheckingAuth) {
        return null;
      }
      
      final isLoggedIn = authState.user != null;
      final isAuthRoute = state.matchedLocation == '/' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';
      
      if (!isLoggedIn && !isAuthRoute) {
        return '/';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/transactions',
        name: 'transactions',
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});