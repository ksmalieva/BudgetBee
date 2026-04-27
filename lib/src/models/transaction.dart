import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class IncomeCategory {
  final String value;
  final String label;
  final IconData icon;
  
  const IncomeCategory({required this.value, required this.label, required this.icon});
  
  static const List<IncomeCategory> categories = [
    IncomeCategory(value: 'salary', label: 'Salary', icon: Icons.work),
    IncomeCategory(value: 'freelance', label: 'Freelance', icon: Icons.code),
    IncomeCategory(value: 'investments', label: 'Investments', icon: Icons.trending_up),
    IncomeCategory(value: 'gift', label: 'Gift', icon: Icons.card_giftcard),
    IncomeCategory(value: 'other_income', label: 'Other', icon: Icons.more_horiz),
  ];
  
  static IncomeCategory fromValue(String value) {
    return categories.firstWhere(
      (c) => c.value == value,
      orElse: () => categories.last,
    );
  }
}

class ExpenseCategory {
  final String value;
  final String label;
  final IconData icon;
  
  const ExpenseCategory({required this.value, required this.label, required this.icon});
  
  static const List<ExpenseCategory> categories = [
    ExpenseCategory(value: 'food', label: 'Food', icon: Icons.restaurant),
    ExpenseCategory(value: 'transport', label: 'Transport', icon: Icons.directions_car),
    ExpenseCategory(value: 'shopping', label: 'Shopping', icon: Icons.shopping_bag),
    ExpenseCategory(value: 'entertainment', label: 'Entertainment', icon: Icons.movie),
    ExpenseCategory(value: 'bills', label: 'Bills', icon: Icons.receipt),
    ExpenseCategory(value: 'education', label: 'Education', icon: Icons.school),
    ExpenseCategory(value: 'health', label: 'Health', icon: Icons.health_and_safety),
    ExpenseCategory(value: 'other_expense', label: 'Other', icon: Icons.more_horiz),
  ];
  
  static ExpenseCategory fromValue(String value) {
    return categories.firstWhere(
      (c) => c.value == value,
      orElse: () => categories.last,
    );
  }
}

class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(String id, Map<String, dynamic> map, TransactionType type) {
    return Transaction(
      id: id,
      type: type,
      amount: map['amount']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }
}