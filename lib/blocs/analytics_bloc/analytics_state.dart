part of 'analytics_bloc.dart';

enum AnalyticsStatus { initial, loading, loaded, error }

final class AnalyticsState {
  final AnalyticsStatus status;
  final Analytics analyse;

  AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.analyse = const Analytics(
      averageMood: 0,
      moodDistribution: {},
      tagFrequency: {},
    ),
  });

  AnalyticsState copyWith({AnalyticsStatus? status, Analytics? analyse}) {
    return AnalyticsState(
      status: status ?? this.status,
      analyse: analyse ?? this.analyse,
    );
  }
}
