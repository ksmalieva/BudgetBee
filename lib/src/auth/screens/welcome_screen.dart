import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmOffWhite,
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Hero Section
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        
                        // App Icon/Logo
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryYellow,
                                AppTheme.primaryYellow.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            size: 50,
                            color: AppTheme.nearBlack,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Title
                        Text(
                          'BudgetBee',
                          style: GoogleFonts.inter(
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.nearBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Subtitle
                        Text(
                          'Smart Budgeting Made Simple',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryYellow,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Description
                        Text(
                          'Take control of your finances with BudgetBee. Track expenses, set savings goals, and build better money habits.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            height: 1.5,
                            color: AppTheme.warmGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Feature Pills
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildFeaturePill('Track Spending', Icons.trending_up),
                            _buildFeaturePill('Save Money', Icons.savings),
                            _buildFeaturePill('Set Goals', Icons.flag),
                            _buildFeaturePill('Get Insights', Icons.insights),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // CTA Section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Get Started Button (goes to Register)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.push('/register'),  // ← Fixed navigation
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryYellow,
                          foregroundColor: AppTheme.nearBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Get Started'),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: AppTheme.nearBlack,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Sign In Button (goes to Login)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        onPressed: () => context.push('/login'),  // ← Fixed navigation
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.warmGray,
                          textStyle: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: GoogleFonts.inter(
                              color: AppTheme.warmGray,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: GoogleFonts.inter(
                                  color: AppTheme.primaryYellow,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Decorative gradient at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.primaryYellow.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryYellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: AppTheme.primaryYellow.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppTheme.primaryYellow,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.nearBlack,
            ),
          ),
        ],
      ),
    );
  }
}