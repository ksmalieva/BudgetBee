import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/financial_provider.dart';
import '../../theme/app_theme.dart';

class EmployeeDashboard extends StatefulWidget {
  final FinancialData financialData;
  
  const EmployeeDashboard({super.key, required this.financialData});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  @override
  Widget build(BuildContext context) {
    final totalIncome = widget.financialData.income;
    final totalExpenses = widget.financialData.expenses;
    final balance = widget.financialData.totalBalance;
    final savingsRate = totalIncome > 0 ? ((totalIncome - totalExpenses) / totalIncome) * 100 : 0;
    final budgetUsage = totalIncome > 0 ? (totalExpenses / totalIncome) * 100 : 0;
    final timeOfDay = _getTimeOfDay();
    
    // Sample income sources
    final Map<String, double> incomeByCategory = {
      'Salary': 3500.0,
      'Freelance': 800.0,
      'Investments': 200.0,
    };
    
    // Sample savings goals
    final totalSavingsCurrent = 3500.0;
    final totalSavingsTarget = 10000.0;
    final savingsProgress = (totalSavingsCurrent / totalSavingsTarget) * 100;
    
    final topExpenses = {
      'Housing': 1200.0,
      'Transport': 300.0,
      'Food': 450.0,
      'Entertainment': 200.0,
      'Utilities': 180.0,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good $timeOfDay,',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.warmGray,
                    ),
                  ),
                  Text(
                    'Professional',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.nearBlack,
                    ),
                  ),
                ],
              ),
              FloatingActionButton.small(
                onPressed: () {
                  // TODO: Navigate to add transaction
                },
                backgroundColor: AppTheme.primaryYellow,
                child: const Icon(Icons.add, color: AppTheme.nearBlack),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Financial Overview Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryYellow, AppTheme.primaryYellow.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Net Worth',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.nearBlack.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${balance.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.nearBlack,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Savings Rate',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.nearBlack.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${savingsRate.toStringAsFixed(1)}%',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.nearBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildOverviewStat(
                        Icons.arrow_upward,
                        'Income',
                        '\$${totalIncome.toStringAsFixed(2)}',
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOverviewStat(
                        Icons.arrow_downward,
                        'Expenses',
                        '\$${totalExpenses.toStringAsFixed(2)}',
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Income Sources',
                  '${incomeByCategory.length}',
                  Icons.account_balance_wallet,
                  'Active streams',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Budget Used',
                  '${budgetUsage.toInt()}%',
                  Icons.adjust,
                  budgetUsage >= 80 ? 'Warning' : 'On track',
                  isWarning: budgetUsage >= 80,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Income Sources Chart
          if (incomeByCategory.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Income Sources',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.nearBlack,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Details',
                          style: GoogleFonts.inter(
                            color: AppTheme.primaryYellow,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...incomeByCategory.entries.map((entry) {
                    final percentage = (entry.value / totalIncome) * 100;
                    return _buildIncomeSourceItem(entry.key, entry.value, percentage);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Budget Progress
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Budget',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.nearBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalExpenses.toStringAsFixed(0)} of \$5,000',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.warmGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (budgetUsage / 100).clamp(0.0, 1.0),
                          backgroundColor: AppTheme.warmGray.withOpacity(0.2),
                          color: _getBudgetColor(budgetUsage.toDouble()),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _buildSmallProgressRing(budgetUsage.toDouble()),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Savings Goals Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Savings Goals',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.nearBlack,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Manage',
                              style: GoogleFonts.inter(
                                color: AppTheme.primaryYellow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '\$${totalSavingsCurrent.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.nearBlack,
                        ),
                      ),
                      Text(
                        'of \$${totalSavingsTarget.toStringAsFixed(0)} total goals',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.warmGray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '2 active goals',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.primaryYellow,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildProgressRing(savingsProgress),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Spending Breakdown
          if (topExpenses.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spending Breakdown',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.nearBlack,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.bar_chart, size: 16, color: AppTheme.primaryYellow),
                      const SizedBox(width: 4),
                      Text(
                        'Reports',
                        style: GoogleFonts.inter(
                          color: AppTheme.primaryYellow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: Column(
                children: topExpenses.entries.map((entry) {
                  final percentage = (entry.value / totalExpenses) * 100;
                  return _buildExpenseItem(entry.key, entry.value, percentage);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Add Income',
                  'Record earnings',
                  Icons.trending_up,
                  AppTheme.primaryYellow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Add Expense',
                  'Track spending',
                  Icons.trending_down,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(IconData icon, String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.nearBlack.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.nearBlack.withOpacity(0.7),
            ),
          ),
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

  Widget _buildStatCard(String title, String value, IconData icon, String subtitle, {bool isWarning = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: isWarning ? Colors.orange : AppTheme.primaryYellow),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.warmGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isWarning ? Colors.orange : AppTheme.nearBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.warmGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeSourceItem(String name, double amount, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.nearBlack,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (percentage / 100).clamp(0.0, 1.0),
                    backgroundColor: AppTheme.warmGray.withOpacity(0.2),
                    color: AppTheme.primaryYellow,
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: AppTheme.nearBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(String name, double amount, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.nearBlack,
                ),
              ),
              Text(
                '\$${amount.toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.warmGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              backgroundColor: AppTheme.warmGray.withOpacity(0.2),
              color: AppTheme.primaryYellow,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.nearBlack,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.warmGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRing(double progress) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: (progress / 100).clamp(0.0, 1.0),
              strokeWidth: 8,
              backgroundColor: AppTheme.warmGray.withOpacity(0.2),
              color: AppTheme.primaryYellow,
            ),
          ),
          Icon(Icons.savings, size: 28, color: AppTheme.primaryYellow),
        ],
      ),
    );
  }

  Widget _buildSmallProgressRing(double progress) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: (progress / 100).clamp(0.0, 1.0),
              strokeWidth: 6,
              backgroundColor: AppTheme.warmGray.withOpacity(0.2),
              color: _getBudgetColor(progress),
            ),
          ),
          Text(
            '${progress.toInt()}%',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.nearBlack,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppTheme.pureWhite,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Color _getBudgetColor(double usage) {
    if (usage >= 100) return Colors.red;
    if (usage >= 80) return Colors.orange;
    return AppTheme.primaryYellow;
  }
}