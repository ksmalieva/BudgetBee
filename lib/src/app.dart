import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/screens/welcome_screen.dart';
import 'auth/screens/login_screen.dart';
import 'auth/screens/register_screen.dart';
import 'auth/screens/forgot_password_screen.dart';
import 'dashboard/screens/dashboard_screen.dart';
import 'profile/screens/profile_screen.dart';
import 'transactions/screens/transactions_screen.dart';
import 'theme/app_theme.dart';

class BudgetBeeApp extends ConsumerWidget {
  const BudgetBeeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final themeMode = ref.watch(themeProvider);
    
    final router = GoRouter(
      initialLocation: '/',
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
    
    return MaterialApp.router(
      title: 'BudgetBee',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      routerConfig: router,
    );
  }
}