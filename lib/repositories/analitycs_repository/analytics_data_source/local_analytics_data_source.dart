import 'dart:async';

import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/models/tag.dart';

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
  Future<Analytics> getEntryAnalytics(
    Period period,
    List<JournalEntry> entries,
  ) async {
    double totalMood = 0;
    int moodCount = 0;
    JournalEntry? bestDay;
    JournalEntry? worstDay;
    final Map<Tag, double> tagAverageMood = {};
    final Map<Mood, int> moodDistribution = {};
    final Map<Tag, int> tagFrequency = {};

    final limitDate = DateTime.now().subtract(Duration(days: period.value));
    final Map<Tag, List<int>> tagMoodScores = {};

    final filteredEntries = entries.where((entry) {
      return entry.date.isAfter(limitDate);
    }).toList();

    for (JournalEntry entry in filteredEntries) {
      totalMood += entry.mood.value;
      moodCount++;

      moodDistribution[entry.mood] = (moodDistribution[entry.mood] ?? 0) + 1;

      for (final tag in entry.tags) {
        tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;

        tagMoodScores.putIfAbsent(tag, () => []);
        tagMoodScores[tag]!.add(entry.mood.value);
      }
      if (bestDay == null || entry.mood.value > bestDay.mood.value) {
        bestDay = entry;
      }
      if (worstDay == null || entry.mood.value < worstDay.mood.value) {
        worstDay = entry;
      }
    }

    for (final entry in tagMoodScores.entries) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      tagAverageMood[entry.key] = avg;
    }

    final averageMood = moodCount > 0 ? totalMood / moodCount : 0;

    final analytics = Analytics(
      averageMood: averageMood,
      moodDistribution: moodDistribution,
      tagFrequency: tagFrequency,
      bestDay: bestDay,
      worstDay: worstDay,
      tagAverageMood: tagAverageMood,
    );

    _controller.add(analytics);

    return analytics;
  }

  @override
  Future<void> updateEntryAnalytics(
    Period period,
    List<JournalEntry> entries,
  ) async {
    //await _emitAnalytics(period, entries);
  }
}
