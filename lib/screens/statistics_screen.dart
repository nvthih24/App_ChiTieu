import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/app_colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final categoryData = provider.getCategoryData();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Thống kê chi tiêu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: categoryData.isEmpty
          ? const Center(child: Text("Chưa có dữ liệu chi tiêu để thống kê"))
          : Column(
              children: [
                const SizedBox(height: 30),
                // 1. BIỂU ĐỒ TRÒN
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 5,
                      centerSpaceRadius: 60,
                      sections: _buildChartSections(categoryData),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // 2. CHÚ THÍCH (Legend)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: categoryData.entries
                        .map((e) => _buildLegendItem(e.key, e.value))
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }

  // Hàm tạo các miếng bánh trong biểu đồ
  List<PieChartSectionData> _buildChartSections(Map<String, double> data) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ];
    int i = 0;
    return data.entries.map((e) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        value: e.value,
        title:
            '${((e.value / data.values.fold(0, (a, b) => a + b)) * 100).toStringAsFixed(1)}%',
        color: color,
        radius: 50,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }).toList();
  }

  // Widget vẽ dòng chú thích bên dưới
  Widget _buildLegendItem(String name, double amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            "${amount.toStringAsFixed(0)} đ",
            style: const TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
