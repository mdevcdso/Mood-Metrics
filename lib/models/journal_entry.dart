import 'package:mood_metrics/models/mood.dart';
import 'package:mood_metrics/models/tag.dart';

final class JournalEntry {
  final int? id;
  final DateTime date;
  final Mood mood;
  final double? weight;
  final String notes;
  final List<Tag> tags;

  const JournalEntry({
    this.id,
    required this.date,
    required this.mood,
    this.weight,
    this.notes = '',
    this.tags = const [],
  });
}
