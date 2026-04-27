import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class BudgetBeeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  
  const BudgetBeeBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.pureWhite,
      selectedItemColor: AppTheme.primaryYellow,
      unselectedItemColor: AppTheme.warmGray,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/dashboard');
            break;
          case 1:
            context.go('/transactions');
            break;
          case 2:
            // Goals screen (coming soon)
            break;
          case 3:
            // Reports screen (coming soon)
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag_outlined),
          activeIcon: Icon(Icons.flag),
          label: 'Goals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}