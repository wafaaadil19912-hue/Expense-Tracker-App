import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/transaction_card.dart';
import '../widgets/summary_card.dart';
import 'add_transaction_screen.dart';
import 'summary_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(controller),
      body: Obx(() => _buildBody(controller)),
      floatingActionButton: _buildFAB(),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────

  AppBar _buildAppBar(TransactionController controller) {
    return AppBar(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        AppConstants.appName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.category),
          tooltip: 'Categories',
          onPressed: () => Get.to(
            () => const CategoriesScreen(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart),
          tooltip: 'Monthly Summary',
          onPressed: () => Get.to(
            () => const SummaryScreen(),
          ),
        ),
      ],
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────
// Add to HomeScreen AppBar actions

  Widget _buildBody(TransactionController controller) {
    return Column(
      children: [
        _buildMonthSelector(controller),
        _buildSummaryRow(controller),
        const SizedBox(height: 8),
        Expanded(child: _buildTransactionList(controller)),
      ],
    );
  }

  // ─── Month Selector ───────────────────────────────────────────────────────

  Widget _buildMonthSelector(TransactionController controller) {
    return Container(
      color: AppConstants.primaryColor,
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: controller.previousMonth,
          ),
          Text(
            Formatters.monthYear(controller.selectedMonth.value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: controller.nextMonth,
          ),
        ],
      ),
    );
  }

  // ─── Summary Row ──────────────────────────────────────────────────────────

  Widget _buildSummaryRow(TransactionController controller) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: SummaryCard(
              label: 'Income',
              amount: controller.totalIncome,
              color: AppConstants.incomeColor,
              icon: Icons.arrow_downward,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SummaryCard(
              label: 'Expenses',
              amount: controller.totalExpenses,
              color: AppConstants.expenseColor,
              icon: Icons.arrow_upward,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SummaryCard(
              label: 'Balance',
              amount: controller.balance,
              color: AppConstants.primaryColor,
              icon: Icons.account_balance_wallet,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Transaction List ─────────────────────────────────────────────────────

  Widget _buildTransactionList(TransactionController controller) {
    final txList = controller.monthlyTransactions;

    if (txList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('No transactions this month',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: txList.length,
      itemBuilder: (context, index) {
        return TransactionCard(transaction: txList[index]);
      },
    );
  }

  // ─── FAB ──────────────────────────────────────────────────────────────────

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text('Add'),
      onPressed: () => Get.to(() => const AddTransactionScreen()),
    );
  }
}
