

import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/models/period.dart';

abstract class AnalyticsDataSource {
  Stream<Analytics> watchAnalytics();
  Future<Analytics> getEntryAnalytics(Period period);
  Future<void> updateEntryAnalytics(Period period);
}