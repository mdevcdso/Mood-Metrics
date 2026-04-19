

import 'dart:async';
import 'dart:developer';

import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/models/journal_entry.dart';
import 'package:mood_metrics/models/period.dart';

import '../journal_repository/JournalRepository.dart';
import 'analytics_data_source/analytics_data_source.dart';

final class AnalyticsRepository {
  final AnalyticsDataSource dataSource;
  final JournalRepository journalRepository;

  AnalyticsRepository({
    required this.dataSource,
    required this.journalRepository,
  });

  Stream<Analytics> watchAnalytics() {
    return journalRepository.watchEntries().asyncMap(
          (entries) => dataSource.getEntryAnalytics(Period.week, entries),
    );
  }

  Future<Analytics?> getEntryAnalytics(Period period) async {
    try {
      final entries = await journalRepository.watchEntries().first;
      return await dataSource.getEntryAnalytics(period, entries);
    } catch (error, stackTrace) {
      log('Erreur Get Analytics: $error', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Analytics> updateEntryAnalytics(Period period, List<JournalEntry> entries) async {
    try {
      log('nouvele analyse: ${entries.length} entries');
      return await dataSource.getEntryAnalytics(period, entries);
    } catch (error, stackTrace) {
      log('Erreur update Analytics: $error', stackTrace: stackTrace);
      rethrow;
    }
  }
}