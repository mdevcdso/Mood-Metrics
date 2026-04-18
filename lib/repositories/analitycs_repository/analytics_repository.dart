

import 'dart:async';
import 'dart:developer';

import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/models/journal_entry.dart';
import 'package:mood_metrics/models/period.dart';

import '../journal_repository/JournalRepository.dart';
import 'analytics_data_source/analytics_data_source.dart';

final class AnalyticsRepository {
  final AnalyticsDataSource dataSource;

  AnalyticsRepository({required this.dataSource});

  Stream<Analytics> watchAnalytics() => dataSource.watchAnalytics();

  Future<Analytics?> getEntryAnalytics(Period period, List<JournalEntry> entries) async {
    try {
      return await dataSource.getEntryAnalytics(period, entries);
    } catch (error, stackTrace) {
      log('Erreur Get Analytics: $error', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateEntryAnalytics(Period period, List<JournalEntry> entries) async {
    try {
      await dataSource.updateEntryAnalytics(period, entries);
    } catch (error) {
      rethrow;
    }
  }
}