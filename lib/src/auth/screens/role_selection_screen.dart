import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String _selectedRole = 'student';
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
        automaticallyImplyLeading: false, // Don't show back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_add,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to BudgetBee!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Please select how you want to use the app:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // Student Option
            _buildRoleCard(
              title: 'Student',
              description: 'Track expenses, manage budget, save for goals',
              icon: Icons.school,
              color: Colors.blue,
              isSelected: _selectedRole == 'student',
              onTap: () {
                setState(() {
                  _selectedRole = 'student';
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Employee Option
            _buildRoleCard(
              title: 'Employee',
              description: 'Income tracking, bill management, investment planning',
              icon: Icons.work,
              color: Colors.green,
              isSelected: _selectedRole == 'employee',
              onTap: () {
                setState(() {
                  _selectedRole = 'employee';
                });
              },
            ),
            
            const SizedBox(height: 32),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isUpdating
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _updateUserRole(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
            
            const SizedBox(height: 16),
            
            // Skip/Logout option
            TextButton(
              onPressed: () async {
                // If user doesn't want to select role, log them out
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/');
                }
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected 
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserRole() async {
    setState(() => _isUpdating = true);
    
    try {
      // Update user role in Firebase
      await ref.read(authProvider.notifier).updateUserRole(_selectedRole);
      
      if (mounted) {
        // Navigate to dashboard after role selection
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}