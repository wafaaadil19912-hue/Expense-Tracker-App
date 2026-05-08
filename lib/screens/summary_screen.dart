import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import 'package:get/get.dart'; // Required for controller access
import '../controllers/transaction_controller.dart'; // Required for _controller
import '../widgets/custom_pie_chart.dart'; // Required to use CustomPieChart

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Monthly Summary'),
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: // Inside your build method in the summary/home screen
            Obx(() => Column(
                  children: [
                    const Text("Expense Distribution",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    CustomPieChart(dataMap: controller.expenseByCategory),
                    const Divider(),
                    const Text("Income Sources",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    CustomPieChart(dataMap: controller.incomeByCategory),
                  ],
                )));
  }

  // ─── Totals ───────────────────────────────────────────────────────────────

  Widget _buildTotalsRow(TransactionController c) {
    return Row(
      children: [
        _statCard('Income', c.totalIncome, AppConstants.incomeColor),
        const SizedBox(width: 8),
        _statCard('Expenses', c.totalExpenses, AppConstants.expenseColor),
        const SizedBox(width: 8),
        _statCard('Balance', c.balance, AppConstants.primaryColor),
      ],
    );
  }

  Widget _statCard(String label, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(Formatters.currency(amount),
                style: TextStyle(
                    color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ─── Pie Chart ────────────────────────────────────────────────────────────

  Widget _buildPieChart(TransactionController controller) {
    final spending = controller.categorySpending;
    if (spending.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No expense data to display')),
      );
    }

    final sections = spending.entries.map((e) {
      final category = controller.getCategoryById(e.key);
      return PieChartSectionData(
        value: e.value,
        color: category?.color ?? Colors.grey,
        title: category?.name ?? '',
        radius: 80,
        titleStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Column(
      children: [
        const Text('Spending by Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Category Breakdown ───────────────────────────────────────────────────

  Widget _buildCategoryBreakdown(TransactionController controller) {
    final spending = controller.categorySpending;
    if (spending.isEmpty) return const SizedBox.shrink();

    final total = spending.values.fold(0.0, (a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...spending.entries.map((e) {
          final cat = controller.getCategoryById(e.key);
          final percent = total > 0 ? (e.value / total * 100) : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(cat?.icon, color: cat?.color, size: 18),
                      const SizedBox(width: 6),
                      Text(cat?.name ?? 'Unknown'),
                    ]),
                    Text(Formatters.currency(e.value),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percent / 100,
                  backgroundColor: Colors.grey.shade200,
                  color: cat?.color ?? Colors.grey,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                Text('${percent.toStringAsFixed(1)}%',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          );
        }),
      ],
    );
  }
}
