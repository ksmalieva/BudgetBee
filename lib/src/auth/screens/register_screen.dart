import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // Step 1: User Info
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  
  // Step 2: User Type Selection
  String? _selectedUserType;
  bool _isLoading = false;
  String _error = '';
  
  // Step management
  int _currentStep = 1; // 1: Info, 2: Type selection

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_currentStep == 2) {
      setState(() {
        _currentStep = 1;
        _error = '';
      });
    } else {
      context.go('/');
    }
  }

  void _handleInfoSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep = 2;
        _error = '';
      });
    }
  }

  Future<void> _handleTypeSelect(String userType) async {
    setState(() {
      _selectedUserType = userType;
      _isLoading = true;
      _error = '';
    });

    try {
      final success = await ref.read(authProvider.notifier).registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
        userType,
      );

      if (success && mounted) {
        // Registration successful, navigate to dashboard
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.go('/dashboard');
        }
      } else if (mounted) {
        setState(() {
          _error = ref.read(authProvider).errorMessage ?? 'Registration failed. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmOffWhite,
      body: SafeArea(
        child: _currentStep == 1 ? _buildInfoStep() : _buildTypeSelectionStep(),
      ),
    );
  }

  // Step 1: User Information Form
  Widget _buildInfoStep() {
    return Column(
      children: [
        // Header with back button
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: _goBack,
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.pureWhite,
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Title
                Text(
                  'Create Account',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.nearBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join BudgetBee and start saving smarter',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.warmGray,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.nearBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_outline, color: AppTheme.warmGray),
                              hintText: 'Enter your name',
                              filled: true,
                              fillColor: AppTheme.pureWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Email Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.nearBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined, color: AppTheme.warmGray),
                              hintText: 'Enter your email',
                              filled: true,
                              fillColor: AppTheme.pureWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.nearBlack,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline, color: AppTheme.warmGray),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword ? Icons.visibility_off : Icons.visibility,
                                  color: AppTheme.warmGray,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                              hintText: 'Create a password',
                              filled: true,
                              fillColor: AppTheme.pureWhite,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Minimum 6 characters',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.warmGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleInfoSubmit,
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
                    ),
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        
        // Footer with login link
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: GoogleFonts.inter(color: AppTheme.warmGray),
              ),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryYellow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 2: User Type Selection
  Widget _buildTypeSelectionStep() {
    return Column(
      children: [
        // Header with back button
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: _goBack,
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.pureWhite,
                  shape: const CircleBorder(),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Choose Your Profile',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.nearBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select the option that best describes you',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.warmGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Error message
                if (_error.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _error,
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                // Student Option Card
                _buildUserTypeCard(
                  title: 'Student',
                  description: 'Simple budgeting for allowances, part-time income, and student expenses',
                  icon: Icons.school,
                  tags: const ['Weekly budgets', 'Savings goals', 'Expense tracking'],
                  isSelected: _selectedUserType == 'student',
                  onTap: () => _handleTypeSelect('student'),
                ),
                const SizedBox(height: 16),
                
                // Employee Option Card
                _buildUserTypeCard(
                  title: 'Employee',
                  description: 'Advanced tracking for salary, multiple income sources, and detailed analytics',
                  icon: Icons.work,
                  tags: const ['Financial reports', 'Multi-income', 'Analytics'],
                  isSelected: _selectedUserType == 'employee',
                  onTap: () => _handleTypeSelect('employee'),
                ),
                
                if (_isLoading) ...[
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryYellow),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Creating your account...',
                          style: GoogleFonts.inter(
                            color: AppTheme.warmGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeCard({
    required String title,
    required String description,
    required IconData icon,
    required List<String> tags,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryYellow : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppTheme.primaryYellow,
              ),
            ),
            const SizedBox(width: 16),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.nearBlack,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryYellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: AppTheme.nearBlack,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.warmGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Tags
                  Wrap(
                    spacing: 8,
                    children: tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.warmGray.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.warmGray,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}