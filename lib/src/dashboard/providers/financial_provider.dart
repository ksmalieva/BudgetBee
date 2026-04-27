import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final financialProvider = FutureProvider.autoDispose<FinancialData>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not logged in');
  
  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    
    if (doc.exists) {
      return FinancialData.fromMap(doc.data()!);
    }
  } catch (e) {
    
  }
  
  // Return default data if Firestore fails
  return FinancialData(
    totalBalance: 1250.75,
    income: 2500.00,
    expenses: 1249.25,
    userType: 'student',
  );
});

class FinancialData {
  final double totalBalance;
  final double income;
  final double expenses;
  final String userType;

  FinancialData({
    required this.totalBalance,
    required this.income,
    required this.expenses,
    required this.userType,
  });

  factory FinancialData.fromMap(Map<String, dynamic> map) {
    return FinancialData(
      totalBalance: (map['totalBalance'] ?? 0).toDouble(),
      income: (map['income'] ?? 0).toDouble(),
      expenses: (map['expenses'] ?? 0).toDouble(),
      userType: map['userType'] ?? 'student',
    );
  }
}