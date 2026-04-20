part of 'analytics_bloc.dart';

@immutable
sealed class AnalyticsEvent {}

final class LoadAnalytics extends AnalyticsEvent {
  final Period period;
  //final List<JournalEntry> entries;

  LoadAnalytics({
    required this.period,
    //required this.entries
  });

}

final class UpdateAnalytics extends AnalyticsEvent {
  //final Period period;
  final List<JournalEntry> entries;

  UpdateAnalytics({
    //required this.period,
    required this.entries
});
}

