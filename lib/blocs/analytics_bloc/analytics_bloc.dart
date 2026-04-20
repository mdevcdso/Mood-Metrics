import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mood_metrics/models/analytics.dart';
import 'package:mood_metrics/repositories/analitycs_repository/analytics_repository.dart';

import '../../models/journal_entry.dart';
import '../../models/mood.dart';
import '../../models/period.dart';
import '../../repositories/journal_repository/JournalRepository.dart';

part 'analytics_event.dart';

part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  late List<JournalEntry> _currentEntries;

  final JournalRepository journalRepository;
  final AnalyticsRepository analyticsRepository;
  StreamSubscription<List<JournalEntry>>? _journalSubscription;

  AnalyticsBloc({
    required this.journalRepository,
    required this.analyticsRepository,
  }) : super(AnalyticsState()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<UpdateAnalytics>(_onUpdateAnalytics);
    _currentEntries = [];

    _journalSubscription =
        journalRepository.watchEntries().listen((entries) {
          _currentEntries = entries;

          add(UpdateAnalytics(
            entries: entries,
          ));
        });
  }

  Future<void> _onLoadAnalytics(
      LoadAnalytics event,
      Emitter<AnalyticsState> emit,
      ) async {
    emit(state.copyWith(status: AnalyticsStatus.loading));

    try {
      final analytics = await analyticsRepository.getEntryAnalytics(
        event.period,
        _currentEntries,
      );

      emit(state.copyWith(
        status: AnalyticsStatus.loaded,
        analyse: analytics,
        period: event.period,
      ));
    } catch (_) {
      emit(state.copyWith(status: AnalyticsStatus.error));
    }
  }

  Future<void> _onUpdateAnalytics(
    UpdateAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      final analytics = await analyticsRepository.updateEntryAnalytics(
        state.period,
        event.entries,
      );
      emit(
        state.copyWith(
          status: AnalyticsStatus.loaded,
          analyse: analytics,
          period: state.period,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: AnalyticsStatus.error));
    }
  }

  @override
  Future<void> close() {
    _journalSubscription?.cancel();
    return super.close();
  }
}
