part of 'analytics_bloc.dart';

@immutable
sealed class AnalyticsEvent {}

final class LoadAnalytics extends AnalyticsEvent {
  final Period period;

  LoadAnalytics({
    required this.period,
  });

}

final class UpdateAnalytics extends AnalyticsEvent {
  final List<JournalEntry> entries;

  UpdateAnalytics({
    required this.entries
});
}

