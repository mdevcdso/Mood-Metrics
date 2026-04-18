

import 'package:mood_metrics/blocs/journal_bloc/journal_bloc.dart';
import 'package:mood_metrics/models/journal_entry.dart';

final class Analytics {
  final double averageMood;
  final Map<DateTime, int> moodDistribution;
  final Map<DateTime, int> tagFrequency;
  final double? averageWeight;
  final JournalBloc? bestDay;
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