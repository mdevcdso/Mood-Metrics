
import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/models/tag.dart';
import 'package:sqflite/sqflite.dart';

import '../../../database/database_helper.dart';
import '../../../models/journal_entry.dart';
import '../../../models/mood.dart';
import '../../../models/period.dart';
import 'analytics_data_source.dart';

final class LocalAnalyticsDataSource implements AnalyticsDataSource {
  final _controller = StreamController<Analytics>.broadcast();




  @override
  Stream<Analytics> watchAnalytics() {
    return _controller.stream;
  }

  @override
  Future<Analytics> getEntryAnalytics(Period period, List<JournalEntry> entries) async {
    double totalMood = 0;
    int moodCount = 0;
    final Map<Mood, int> moodDistribution = {};
    final Map<Tag, int> tagFrequency = {};
    double totalWeight = 0;
    int weightCount = 0;
    JournalEntry? bestDay;
    JournalEntry? worstDay;

    for (JournalEntry entry in entries) {
      totalMood += entry.mood.value;
      moodCount++;

      moodDistribution[entry.mood] =
          (moodDistribution[entry.mood] ?? 0) + 1;

      for (final tag in entry.tags) {
        tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;
      }

      if (entry.weight != null) {
        totalWeight += entry.weight!;
        weightCount++;
      }

      if (bestDay == null ||
          entry.mood.value > bestDay.mood.value) {
        bestDay = entry;
      }

      if (worstDay == null ||
          entry.mood.value < worstDay.mood.value) {
        worstDay = entry;
      }
    }

    final averageMood =
    moodCount > 0 ? totalMood / moodCount : 0;

    final averageWeight =
    weightCount > 0 ? totalWeight / weightCount : null;

    final analytics = Analytics(
      averageMood: averageMood,
      moodDistribution: moodDistribution,
      tagFrequency: tagFrequency,
      averageWeight: averageWeight,
      bestDay: bestDay,
      worstDay: worstDay,
    );

    _controller.add(analytics);

    return analytics;
  }

  @override
  Future<void> updateEntryAnalytics(Period period, List<JournalEntry> entries) async {
    //await _emitAnalytics(period, entries);
  }

}