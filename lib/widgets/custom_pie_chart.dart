import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class CustomPieChart extends StatelessWidget {
  final Map<String, double> dataMap;

  const CustomPieChart({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    if (dataMap.isEmpty)
      return const SizedBox(height: 100, child: Center(child: Text("No data")));

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: dataMap.entries.map((entry) {
            final category = StorageService.getCategoryById(entry.key);
            return PieChartSectionData(
              value: entry.value,
              color: category?.color ?? Colors.grey,
              title: category?.name ?? 'Other',
              radius: 50,
              titleStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            );
          }).toList(),
        ),
      ),
    );
  }
}
