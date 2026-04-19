

import 'package:mood_metrics/blocs/journal_bloc/journal_bloc.dart';
import 'package:mood_metrics/models/journal_entry.dart';
import 'package:mood_metrics/models/tag.dart';

final class Analytics {
  final num averageMood;
  final Map<DateTime, int> moodDistribution;
  final Map<DateTime, Tag> tagFrequency;
  final double? averageWeight;
  final JournalEntry? bestDay;
  final JournalEntry? worstDay;

  const Analytics({
    required this.averageMood,
    this.averageWeight,
    required this.moodDistribution,
    required this.tagFrequency,
    this.bestDay,
    this.worstDay,
  });
}