import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/financial_provider.dart';
import '../../theme/app_theme.dart';

class StudentDashboard extends StatefulWidget {
  final FinancialData financialData;
  
  const StudentDashboard({super.key, required this.financialData});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  late String _randomTip;
  
  final List<String> _studentTips = const [
    "Try the 50/30/20 rule: 50% needs, 30% wants, 20% savings!",
    "Pack lunch instead of eating out - save up to \$50/week!",
    "Use student discounts whenever possible.",
    "Set up automatic transfers to your savings.",
    "Review your subscriptions monthly - cancel what you don't use.",
  ];

  @override
  void initState() {
    super.initState();
    _randomTip = _studentTips[DateTime.now().millisecondsSinceEpoch % _studentTips.length];
  }

  @override
  Widget build(BuildContext context) {
    final totalIncome = widget.financialData.income;
    final totalExpenses = widget.financialData.expenses;
    final balance = widget.financialData.totalBalance;
    final double budgetUsage = totalIncome > 0
        ? ((totalExpenses / totalIncome) * 100).toDouble()
        : 0.0;
    
    // Sample expense breakdown
    final Map<String, double> expenseByCategory = {
      'Food': 250.0,
      'Transport': 80.0,
      'Entertainment': 120.0,
      'Books': 200.0,
    };
    
    final topExpenses = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Sample savings goals
    final List<Map<String, dynamic>> savingsGoals = [
      {'name': 'New Laptop', 'current': 450, 'target': 1200},
      {'name': 'Spring Break', 'current': 300, 'target': 800},
    ];

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
                    'Hello,',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.warmGray,
                    ),
                  ),
                  Text(
                    'Student',
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

          // Balance Card with Progress Ring
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.nearBlack.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${balance.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.nearBlack,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildIncomeExpenseIndicator(
                            Icons.arrow_upward,
                            '+\$${totalIncome.toStringAsFixed(0)}',
                            Colors.green,
                          ),
                          const SizedBox(width: 16),
                          _buildIncomeExpenseIndicator(
                            Icons.arrow_downward,
                            '-\$${totalExpenses.toStringAsFixed(0)}',
                            Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildProgressRing(budgetUsage),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Income',
                  '\$${totalIncome.toStringAsFixed(2)}',
                  Icons.wallet,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Expenses',
                  '\$${totalExpenses.toStringAsFixed(2)}',
                  Icons.trending_down,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Budget Progress
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                        Text(
                          _getBudgetStatus(budgetUsage),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: _getBudgetColor(budgetUsage),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${totalExpenses.toStringAsFixed(0)} / \$1,500',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.nearBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (budgetUsage / 100).clamp(0.0, 1.0),
                    backgroundColor: AppTheme.warmGray.withOpacity(0.2),
                    color: _getBudgetColor(budgetUsage),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${(1500 - totalExpenses).clamp(0.0, double.infinity).toStringAsFixed(0)} remaining this month',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.warmGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Savings Goals Preview
          if (savingsGoals.isNotEmpty) ...[
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
                    'See all',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryYellow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...savingsGoals.map((goal) => _buildSavingsGoalCard(goal)),
            const SizedBox(height: 24),
          ],

          // Spending Breakdown
          if (topExpenses.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Expenses',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.nearBlack,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View all',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryYellow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                children: topExpenses.take(4).map((entry) {
                  final percentage = (entry.value / totalExpenses) * 100;
                  return _buildExpenseItem(entry.key, entry.value, percentage);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Budget Tip
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryYellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.lightbulb, color: AppTheme.primaryYellow),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget Tip',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.nearBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _randomTip,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.warmGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseIndicator(IconData icon, String amount, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          amount,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.nearBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRing(double budgetUsage) {
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
              value: (budgetUsage / 100).clamp(0.0, 1.0),
              strokeWidth: 8,
              backgroundColor: AppTheme.nearBlack.withOpacity(0.1),
              color: _getBudgetColor(budgetUsage),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${budgetUsage.toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.nearBlack,
                ),
              ),
              Text(
                'spent',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.warmGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
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
            amount,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.nearBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsGoalCard(Map<String, dynamic> goal) {
    final progress = (goal['current'] / goal['target']) * 100;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.savings, color: AppTheme.primaryYellow),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goal['name'],
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.nearBlack,
                      ),
                    ),
                    Text(
                      '\$${goal['current']}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.nearBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (progress / 100).clamp(0.0, 1.0),
                          backgroundColor: AppTheme.warmGray.withOpacity(0.2),
                          color: AppTheme.primaryYellow,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${progress.toInt()}%',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.warmGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(String category, double amount, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    category[0],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryYellow,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
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

  String _getBudgetStatus(double usage) {
    if (usage >= 100) return 'Over Budget!';
    if (usage >= 80) return 'Almost there!';
    if (usage >= 50) return 'On track';
    return 'Great start!';
  }

  Color _getBudgetColor(double usage) {
    if (usage >= 100) return Colors.red;
    if (usage >= 80) return Colors.orange;
    return AppTheme.primaryYellow;
  }
}