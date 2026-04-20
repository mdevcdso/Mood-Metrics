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

import '../widgets/AnalyticsPiechartWidget.dart';
import '../widgets/MoodByTagCahrtWidget.dart';

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
          final selected = state.period;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: Period.values.map((period) {
                    final isSelected = period == selected;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.read<AnalyticsBloc>().add(
                            LoadAnalytics(period: period),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.grey
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              period.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TagMoodBarChart(
                  data: analytics.tagAverageMood,
                  averageMood: analytics.averageMood.toStringAsFixed(1),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _EntryCard(
                    title: "Meilleur jour",
                    entry: analytics.bestDay,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: _EntryCard(
                    title: "Pire jour",
                    entry: analytics.worstDay,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                AppPieChart<Mood>(
                  data: analytics.moodDistribution,
                  title: "Répartition des Moods",
                  getLabel: (mood) => mood.label,
                  getIndex: (mood) => mood.index,
                )
              ],
            ),
          );
        },
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
