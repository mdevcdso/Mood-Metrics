

import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/models/period.dart';

abstract class AnalyticsDataSource {
  Stream<Analytics> watchAnalytics();
  Future<Map<String, dynamic>> getEntryAnalytics(Period period);
}