

import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/models/journal_entry.dart';
import 'package:mood_metrics/models/period.dart';

abstract class AnalyticsDataSource {
  Stream<Analytics> watchAnalytics();
  Future<Analytics> getEntryAnalytics(Period period, List<JournalEntry> entries);
  Future<void> updateEntryAnalytics(Period period, List<JournalEntry> entries);
}