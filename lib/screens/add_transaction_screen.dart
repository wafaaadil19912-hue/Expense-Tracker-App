import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/transaction_controller.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';
import '../widgets/category_chip.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? existingTransaction;

  const AddTransactionScreen({
    super.key,
    this.existingTransaction,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  final TransactionController _controller = Get.find<TransactionController>();

  String _selectedType = 'expense';
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  bool get isEditing => widget.existingTransaction != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final tx = widget.existingTransaction!;

      _amountCtrl.text = tx.amount.toString();
      _noteCtrl.text = tx.note;
      _selectedType = tx.type;
      _selectedCategoryId = tx.categoryId;
      _selectedDate = tx.date;
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      Get.snackbar(
        'Error',
        'Please select a category',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (isEditing) {
      final tx = widget.existingTransaction!;

      tx.amount = double.parse(_amountCtrl.text.trim());

      tx.categoryId = _selectedCategoryId!;
      tx.date = _selectedDate;
      tx.note = _noteCtrl.text.trim();
      tx.type = _selectedType;

      await _controller.updateTransaction(tx);

      Get.back();

      Get.snackbar(
        'Success',
        'Transaction updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      await _controller.addTransaction(
        amount: double.parse(_amountCtrl.text.trim()),
        categoryId: _selectedCategoryId!,
        date: _selectedDate,
        note: _noteCtrl.text.trim(),
        type: _selectedType,
      );

      Get.back();

      Get.snackbar(
        'Success',
        'Transaction added',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Transaction' : 'Add Transaction',
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeToggle(),
              const SizedBox(height: 20),
              _buildAmountField(),
              const SizedBox(height: 16),
              _buildCategorySelector(),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildNoteField(),
              const SizedBox(height: 28),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Row(
      children: [
        _typeButton(
          'expense',
          'Expense',
          AppConstants.expenseColor,
        ),
        const SizedBox(width: 12),
        _typeButton(
          'income',
          'Income',
          AppConstants.incomeColor,
        ),
      ],
    );
  }

  Widget _typeButton(
    String type,
    String label,
    Color color,
  ) {
    final selected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: selected ? color : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountCtrl,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        labelText: 'Amount',
        prefixText: '\RS ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Amount is required';
        }

        if (double.tryParse(v) == null) {
          return 'Enter a valid number';
        }

        if (double.parse(v) <= 0) {
          return 'Amount must be greater than 0';
        }

        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    return Obx(() {
      final cats = _controller.categories;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cats.map((cat) {
              return CategoryChip(
                category: cat,
                isSelected: _selectedCategoryId == cat.id,
                onTap: () {
                  setState(() {
                    _selectedCategoryId = cat.id;
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget _buildDatePicker() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(
        Icons.calendar_today,
        color: AppConstants.primaryColor,
      ),
      title: const Text('Date'),
      subtitle: Text(
        DateFormat('MMMM dd, yyyy').format(_selectedDate),
      ),
      trailing: const Icon(Icons.edit),
      onTap: _pickDate,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      tileColor: Colors.white,
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      controller: _noteCtrl,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Note (optional)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _submit,
        child: Text(
          isEditing ? 'Update Transaction' : 'Add Transaction',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
