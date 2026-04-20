import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/tag.dart';

class TagMoodBarChart extends StatelessWidget {
  final Map<Tag, double> data;
  final String averageMood;
  final double height;

  const TagMoodBarChart({
    super.key, required this.data,
    required this.averageMood,
    this.height = 250
  });

  Color _color(Tag tag) {
    return Colors.primaries[tag.index % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Impact des Tags sur l'humeur",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _StatCard(
                title: "Mood moyen",
                value: averageMood,
                icon: Icons.tag,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                children: entries.map((entry) {
                  final color = _color(entry.key);

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${entry.key.label} - ${entry.value.toStringAsFixed(1)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: height,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,

              barGroups: entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key.index,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value,
                      width: 14,
                      color: _color(entry.key),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }).toList(),

              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final tag = Tag.values[value.toInt()];
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          tag.label.replaceAll(' ', '\n'),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),

              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
