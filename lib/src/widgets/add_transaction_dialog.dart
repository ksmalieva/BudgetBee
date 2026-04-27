import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  const AddTransactionDialog({super.key});

  @override
  ConsumerState<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  TransactionType _selectedType = TransactionType.expense;
  final _amountController = TextEditingController();
  String? _selectedCategory;
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_amountController.text.isEmpty || _selectedCategory == null) return;

    setState(() => _isLoading = true);

    await ref.read(transactionProvider.notifier).addTransaction(
      type: _selectedType,
      amount: double.parse(_amountController.text),
      category: _selectedCategory!,
      description: _descriptionController.text,
      date: _selectedDate,
    );

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Add Transaction',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.nearBlack,
              ),
            ),
            const SizedBox(height: 20),

            // Transaction Type Toggle
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    'Income',
                    TransactionType.income,
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeButton(
                    'Expense',
                    TransactionType.expense,
                    Icons.trending_down,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount Field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.inter(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: (_selectedType == TransactionType.income
                      ? IncomeCategory.categories
                      : ExpenseCategory.categories)
                  .map<DropdownMenuItem<String>>((cat) {
                    final category = cat as dynamic;
                    return DropdownMenuItem<String>(
                      value: category.value,
                      child: Row(
                        children: [
                          Icon(category.icon, size: 20, color: AppTheme.warmGray),
                          const SizedBox(width: 8),
                          Text(category.label),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: 16),

            // Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: GoogleFonts.inter(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Date Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(_selectedDate.toString().split(' ')[0]),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: AppTheme.nearBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Add ${_selectedType == TransactionType.income ? 'Income' : 'Expense'}',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, TransactionType type, IconData icon, Color color) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppTheme.warmGray.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : AppTheme.warmGray),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? color : AppTheme.warmGray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}