import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/add_transaction_dialog.dart';
import '../../widgets/bottom_nav_bar.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _filter = 'all'; // 'all', 'income', 'expense'
  final DateFormat _dateFormat = DateFormat('EEEE, MMMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final totalIncome = ref.read(transactionProvider.notifier).getTotalIncome();
    final totalExpenses = ref.read(transactionProvider.notifier).getTotalExpenses();

    // Filter transactions
    final filteredTransactions = _filter == 'all'
        ? transactions
        : transactions.where((t) => 
            t.type.toString().split('.').last == _filter).toList();

    // Group by date
    final groupedTransactions = <String, List<Transaction>>{};
    for (var transaction in filteredTransactions) {
      final dateKey = _dateFormat.format(transaction.date);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    return Scaffold(
      backgroundColor: AppTheme.warmOffWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transactions',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.nearBlack,
                        ),
                      ),
                      Text(
                        'Track your money flow',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.warmGray,
                        ),
                      ),
                    ],
                  ),
                  FloatingActionButton.small(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const AddTransactionDialog(),
                    ),
                    backgroundColor: AppTheme.primaryYellow,
                    child: const Icon(Icons.add, color: AppTheme.nearBlack),
                  ),
                ],
              ),
            ),

            // Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildFilterTab('All', 'all'),
                    _buildFilterTab('Income', 'income'),
                    _buildFilterTab('Expense', 'expense'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Income',
                      '\$${totalIncome.toStringAsFixed(2)}',
                      Icons.trending_up,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Expenses',
                      '\$${totalExpenses.toStringAsFixed(2)}',
                      Icons.trending_down,
                      Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Transactions List
            Expanded(
              child: groupedTransactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.pureWhite,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.receipt_long,
                              size: 48,
                              color: AppTheme.warmGray,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions yet',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.nearBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start tracking by adding your first transaction',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.warmGray,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: groupedTransactions.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date header
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today,
                                      size: 14, color: AppTheme.warmGray),
                                  const SizedBox(width: 8),
                                  Text(
                                    entry.key,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.warmGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Transactions for this date
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.pureWhite,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: entry.value.map((transaction) {
                                  return _buildTransactionItem(transaction);
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BudgetBeeBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildFilterTab(String label, String value) {
    final isSelected = _filter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filter = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryYellow : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppTheme.nearBlack : AppTheme.warmGray,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.warmGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.nearBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.type == TransactionType.income;
    final categoryIcon = isIncome
        ? IncomeCategory.fromValue(transaction.category).icon
        : ExpenseCategory.fromValue(transaction.category).icon;
    final categoryLabel = isIncome
        ? IncomeCategory.fromValue(transaction.category).label
        : ExpenseCategory.fromValue(transaction.category).label;
    final amountColor = isIncome ? Colors.green : Colors.red;
    final amountPrefix = isIncome ? '+' : '-';

    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Transaction'),
            content: const Text('Are you sure you want to delete this transaction?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        ref.read(transactionProvider.notifier).deleteTransaction(
          transaction.id,
          transaction.type,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction deleted'), duration: Duration(seconds: 1)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.warmGray.withOpacity(0.1)),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(categoryIcon, size: 20, color: amountColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description.isNotEmpty
                        ? transaction.description
                        : categoryLabel,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.nearBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    categoryLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.warmGray,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}