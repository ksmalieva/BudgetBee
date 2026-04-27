import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/financial_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'student_dashboard.dart';
import 'employee_dashboard.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final financialData = ref.watch(financialProvider);
    
    final userRole = authState.userRole ?? 'student';
    
    return Scaffold(
      body: financialData.when(
        data: (data) {
          if (userRole == 'employee') {
            return EmployeeDashboard(financialData: data);
          } else {
            return StudentDashboard(financialData: data);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          final defaultData = FinancialData(
            totalBalance: 0,
            income: 0,
            expenses: 0,
            userType: userRole,
          );
          if (userRole == 'employee') {
            return EmployeeDashboard(financialData: defaultData);
          } else {
            return StudentDashboard(financialData: defaultData);
          }
        },
      ),
      bottomNavigationBar: const BudgetBeeBottomNavBar(currentIndex: 0),
    );
  }
}