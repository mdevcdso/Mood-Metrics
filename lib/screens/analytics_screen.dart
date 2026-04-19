import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../blocs/analytics_bloc/analytics_bloc.dart';
import '../blocs/journal_bloc/journal_bloc.dart';
import '../models/journal_entry.dart';
import '../models/mood.dart';
import '../models/period.dart';
import '../models/tag.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state.status == AnalyticsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AnalyticsStatus.error) {
            return const Center(child: Text('Erreur de chargement'));
          }

          final analytics = state.analyse;
          final entries = state.analyse.moodDistribution.entries.toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: "Mood moyen",
                        value: analytics.averageMood.toStringAsFixed(1),
                        icon: Icons.emoji_emotions,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: "Poids moyen",
                        value:
                            analytics.averageWeight?.toStringAsFixed(1) ?? "-",
                        icon: Icons.monitor_weight,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: _EntryCard(
                    title: "Meilleur jour",
                    entry: analytics.bestDay,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 12),
                SizedBox(
                  width: double.infinity,
                  child: _EntryCard(
                    title: "Pire jour",
                    entry: analytics.worstDay,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final String title;
  final JournalEntry? entry;
  final Color color;

  const _EntryCard({
    required this.title,
    required this.entry,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final e =
        entry ??
        JournalEntry(
          date: DateTime.now(),
          mood: Mood.neutral,
          weight: null,
          tags: [],
        );
    String formattedDate = DateFormat('dd/MM/yyyy').format(e.date);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mood de ce jour",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  e.mood.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (e.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: e.tags.map((tag) {
                  return Chip(
                    label: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        tag.label,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
