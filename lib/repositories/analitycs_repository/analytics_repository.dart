

import 'dart:async';

import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/models/period.dart';

import '../journal_repository/JournalRepository.dart';
import 'analytics_data_source/analytics_data_source.dart';

final class AnalyticsRepository {
  final AnalyticsDataSource dataSource;
  late final StreamSubscription _subscription;

  AnalyticsRepository({
    required this.dataSource,
    required JournalRepository journalRepository,
  }) {
    _subscription = journalRepository.watchEntries().listen((entries) {
      getEntryAnalytics(Period.week);
    });
  }

  Stream<Analytics> watchAnalytics() {
    try {
      return dataSource.watchAnalytics();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getEntryAnalytics(Period period) async {
    try {
      await dataSource.getEntryAnalytics(period);
    } catch (error) {
      rethrow;
    }
  }

}