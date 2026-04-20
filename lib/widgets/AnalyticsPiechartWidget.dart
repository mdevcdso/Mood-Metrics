import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppPieChart<T> extends StatelessWidget {
  final Map<T, int> data;
  final String Function(T) getLabel;
  final int Function(T) getIndex;
  final double height;
  final double radius;
  final String? title;

  const AppPieChart({
    super.key,
    required this.data,
    required this.getLabel,
    required this.getIndex,
    this.height = 200,
    this.radius = 50,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    final total = entries.fold<int>(0, (sum, e) => sum + e.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 12),
        ],

        SizedBox(
          height: height,
          child: PieChart(
            PieChartData(
              sections: entries.map((entry) {
                final color = Colors
                    .primaries[getIndex(entry.key) % Colors.primaries.length];

                final percent = (entry.value / total * 100);

                return PieChartSectionData(
                  value: entry.value.toDouble(),
                  title: "${percent.toStringAsFixed(0)}%",
                  color: color,
                  radius: radius,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: entries.map((entry) {
            final color =
                Colors.primaries[getIndex(entry.key) % Colors.primaries.length];

            final percent = (entry.value / total * 100);

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "${getLabel(entry.key)} (${entry.value})",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
