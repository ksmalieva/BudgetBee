import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction.dart';

final transactionProvider = StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  return TransactionNotifier();
});

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  
  TransactionNotifier() : super([]) {
    _loadTransactions();
  }

  void _loadTransactions() {
    final user = _auth.currentUser;
    if (user != null) {
      // Listen to income collection
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('incomes')
          .snapshots()
          .listen((snapshot) {
        final incomes = snapshot.docs.map((doc) => Transaction.fromMap(
          doc.id,
          doc.data(),
          TransactionType.income,
        )).toList();
        _mergeTransactions(incomes);
      });

      // Listen to expenses collection
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('expenses')
          .snapshots()
          .listen((snapshot) {
        final expenses = snapshot.docs.map((doc) => Transaction.fromMap(
          doc.id,
          doc.data(),
          TransactionType.expense,
        )).toList();
        _mergeTransactions(expenses);
      });
    }
  }

  void _mergeTransactions(List<Transaction> newTransactions) {
    // Create a map to deduplicate by id
    final Map<String, Transaction> transactionMap = {};
    
    // Add existing transactions
    for (var t in state) {
      transactionMap[t.id] = t;
    }
    
    // Add or update with new transactions
    for (var t in newTransactions) {
      transactionMap[t.id] = t;
    }
    
    final allTransactions = transactionMap.values.toList();
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    state = allTransactions;
  }

  Future<void> addTransaction({
    required TransactionType type,
    required double amount,
    required String category,
    required String description,
    required DateTime date,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final collection = type == TransactionType.income ? 'incomes' : 'expenses';
    
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection(collection)
        .add({
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
    });
  }

  Future<void> deleteTransaction(String id, TransactionType type) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final collection = type == TransactionType.income ? 'incomes' : 'expenses';
    
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection(collection)
        .doc(id)
        .delete();
  }

  double getTotalIncome() {
    return state
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalExpenses() {
    return state
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}