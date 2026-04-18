import 'dart:async';

import 'package:bloc/bloc.dart';
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
  final JournalRepository journalRepository;
  final AnalyticsRepository analyticsRepository;
  StreamSubscription<List<JournalEntry>>? _journalSubscription;

  AnalyticsBloc({
    required this.journalRepository,
    required this.analyticsRepository,
  }) : super(AnalyticsState()) {
    on<LoadAnalytics>(_onLoadAnalytics);
    on<UpdateAnalytics>(_onUpdatePeriodAnalytics);

    _journalSubscription = journalRepository.watchEntries().listen(
          (entries) => add(UpdateAnalytics(period: Period.week, entries: entries)),
    );
  }

  Future<void> _onLoadAnalytics(
    LoadAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(status: AnalyticsStatus.loading));
    try {
      emit(state.copyWith(status: AnalyticsStatus.loading));
      try {
        final analytics = await analyticsRepository.getEntryAnalytics(event.period, event.entries);
        if (analytics != null) {
          emit(state.copyWith(status: AnalyticsStatus.loaded, analyse: analytics));
        } else {
          emit(state.copyWith(status: AnalyticsStatus.error));
        }
      } catch (error) {
        emit(state.copyWith(status: AnalyticsStatus.error));
      }
    } catch (error) {
      emit(state.copyWith(status: AnalyticsStatus.error));
    }
  }

  Future<void> _onUpdatePeriodAnalytics(
    UpdateAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      await analyticsRepository.updateEntryAnalytics(event.period, event.entries);
    } catch (error) {
      emit(state.copyWith(status: AnalyticsStatus.error));
    }
  }




}
