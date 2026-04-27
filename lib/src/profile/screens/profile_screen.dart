import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../dashboard/providers/financial_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isDarkMode = false;
  bool _isSwitchingType = false;

  @override
  void initState() {
    super.initState();
    // You can load dark mode preference from shared preferences here
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final financialData = ref.watch(financialProvider);
    final user = authState.user;
    final userRole = authState.userRole ?? 'student';

    return Scaffold(
      backgroundColor: AppTheme.warmOffWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Profile',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.nearBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your account',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.warmGray,
                ),
              ),
              const SizedBox(height: 24),

              // User Info Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.pureWhite,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 32,
                            color: AppTheme.primaryYellow,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // User info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.email?.split('@').first ?? 'User',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.nearBlack,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    userRole == 'student'
                                        ? Icons.school
                                        : Icons.work,
                                    size: 16,
                                    color: AppTheme.primaryYellow,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${userRole.toUpperCase()} Account',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
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
                    const SizedBox(height: 16),
                    // Email
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.warmGray.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: AppTheme.warmGray,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            user?.email ?? 'No email',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.warmGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Summary
              financialData.when(
                data: (data) {
                  final totalIncome = data.income;
                  final totalExpenses = data.expenses;
                  final totalSaved = totalIncome - totalExpenses;
                  
                  return Row(
                    children: [
                      _buildStatCard('Total Income', '\$${totalIncome.toStringAsFixed(0)}', Icons.trending_up),
                      const SizedBox(width: 12),
                      _buildStatCard('Total Spent', '\$${totalExpenses.toStringAsFixed(0)}', Icons.trending_down),
                      const SizedBox(width: 12),
                      _buildStatCard('Saved', '\$${totalSaved.toStringAsFixed(0)}', Icons.savings, isPrimary: true),
                    ],
                  );
                },
                loading: () => const Row(
                  children: [
                    Expanded(child: Center(child: CircularProgressIndicator())),
                  ],
                ),
                error: (error, stack) => const Row(
                  children: [
                    Expanded(child: Center(child: Text('No data available'))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings Section
              _buildSectionTitle('Settings'),
              const SizedBox(height: 8),
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
                  children: [
                    // Dark Mode Toggle
                    _buildSettingsTile(
                      icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      title: 'Dark Mode',
                      subtitle: _isDarkMode ? 'Currently enabled' : 'Currently disabled',
                      trailing: Switch(
                        value: _isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            _isDarkMode = value;
                          });
                          // TODO: Implement dark mode toggle
                        },
                        activeColor: AppTheme.primaryYellow,
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    
                    // Account Type Switch
                    _buildSettingsTile(
                      icon: userRole == 'student' ? Icons.school : Icons.work,
                      title: 'Account Type',
                      subtitle: '${userRole.toUpperCase()} mode',
                      trailing: _isSwitchingType
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _switchUserType,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: AppTheme.primaryYellow,
                                elevation: 0,
                                side: BorderSide(color: AppTheme.primaryYellow.withOpacity(0.5)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Switch to ${userRole == 'student' ? 'Employee' : 'Student'}',
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                            ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    
                    // Notifications
                    _buildSettingsTile(
                      icon: Icons.notifications_none,
                      title: 'Notifications',
                      subtitle: 'Budget alerts and reminders',
                      onTap: () {
                        // TODO: Navigate to notifications settings
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Support Section
              _buildSectionTitle('Support'),
              const SizedBox(height: 8),
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
                  children: [
                    _buildSettingsTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        _showPrivacyPolicy();
                      },
                    ),
                    const Divider(height: 1, thickness: 1),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {
                        _showHelpCenter();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _showLogoutDialog,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Sign Out',
                        style: GoogleFonts.inter(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // App Version
              Column(
                children: [
                  Text(
                    'BudgetBee v1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.warmGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Made with care for your finances',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.warmGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.warmGray,
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, IconData icon, {bool isPrimary = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: isPrimary ? AppTheme.primaryYellow : AppTheme.warmGray),
            const SizedBox(height: 8),
            Text(
              amount,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isPrimary ? AppTheme.primaryYellow : AppTheme.nearBlack,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppTheme.warmGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryYellow),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.nearBlack,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.warmGray,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else if (onTap != null)
              Icon(Icons.chevron_right, size: 20, color: AppTheme.warmGray),
          ],
        ),
      ),
    );
  }

  Future<void> _switchUserType() async {
    setState(() => _isSwitchingType = true);
    
    try {
      final authState = ref.read(authProvider);
      final currentRole = authState.userRole ?? 'student';
      final newRole = currentRole == 'student' ? 'employee' : 'student';
      
      await ref.read(authProvider.notifier).updateUserRole(newRole);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched to $newRole account'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        // Refresh the screen
        ref.invalidate(authProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error switching account type'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSwitchingType = false);
      }
    }
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text(
          'Your data is stored securely and never shared with third parties. '
          'We use Firebase for authentication and data storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: const Text(
          'For support, please contact us at:\n'
          'support@budgetbee.com\n\n'
          'FAQ:\n'
          '• How to track expenses?\n'
          '• How to set savings goals?\n'
          '• Understanding your dashboard',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        context.go('/');
      }
    }
  }
}