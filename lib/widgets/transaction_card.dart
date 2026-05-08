import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../screens/add_transaction_screen.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();
    final category = controller.getCategoryById(transaction.categoryId);
    final isExpense = transaction.isExpense;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: (category?.color ?? Colors.grey).withOpacity(0.15),
          child: Icon(
            category?.icon ?? Icons.category,
            color: category?.color ?? Colors.grey,
          ),
        ),
        title: Text(
          category?.name ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.note.isNotEmpty)
              Text(transaction.note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12)),
            Text(Formatters.shortDate(transaction.date),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isExpense ? '-' : '+'}${Formatters.currency(transaction.amount)}',
              style: TextStyle(
                color: isExpense
                    ? AppConstants.expenseColor
                    : AppConstants.incomeColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Get.to(() =>
                      AddTransactionScreen(existingTransaction: transaction));
                } else if (value == 'delete') {
                  _confirmDelete(context, controller);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TransactionController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction'),
        content:
            const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteTransaction(transaction.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
