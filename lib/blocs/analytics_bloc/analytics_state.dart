part of 'analytics_bloc.dart';

enum AnalyticsStatus { initial, loading, loaded, error }

final class AnalyticsState {
  final Period period;
  final AnalyticsStatus status;
  final Analytics analyse;

  AnalyticsState({
    this.period = Period.week,
    this.status = AnalyticsStatus.initial,
    this.analyse = const Analytics(
      averageMood: 0,
      moodDistribution: {},
      tagFrequency: {},
      tagAverageMood: {},
    ),
  });

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    Analytics? analyse,
    Period? period,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      analyse: analyse ?? this.analyse,
      period: period ?? this.period,
    );
  }
}
