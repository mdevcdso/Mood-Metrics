import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mood_metrics/repositories/journal_repository/JournalRepository.dart';

import '../../models/journal_entry.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository journalRepository;

  JournalBloc({required this.journalRepository}) : super(JournalState()) {
    on<LoadJournalEntries>(_onLoadJournalEntries);
    on<AddJournalEntry>(_onAddJournalEntry);
    on<DeleteJournalEntry>(_onDeleteJournalEntry);
    on<UpdateJournalEntry>(_onUpdateJournalEntry);
  }

  Future<void> _onAddJournalEntry(
    AddJournalEntry event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await journalRepository.addEntry(event.entry);
    } catch (error) {
      emit(state.copyWith(status: JournalStatus.error));
    }
  }

  Future<void> _onLoadJournalEntries(
    LoadJournalEntries event,
    Emitter<JournalState> emit,
  ) async {
    emit(state.copyWith(status: JournalStatus.loading));
    try {
      await emit.forEach<List<JournalEntry>>(
        journalRepository.watchEntries(),
        onData: (entries) {
          return state.copyWith(status: JournalStatus.loaded, entries: entries);
        },
        onError: (_, __) {
          return state.copyWith(status: JournalStatus.error);
        },
      );
    } catch (error) {
      emit(state.copyWith(status: JournalStatus.error));
    }
  }

  Future<void> _onDeleteJournalEntry(
    DeleteJournalEntry event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await journalRepository.deleteEntry(event.entryId);
    } catch (error) {
      emit(state.copyWith(status: JournalStatus.error));
    }
  }

  Future<void> _onUpdateJournalEntry(
    UpdateJournalEntry event,
    Emitter<JournalState> emit,
  ) async {
    try {
      await journalRepository.updateEntry(event.entry);
    } catch (error) {
      emit(state.copyWith(status: JournalStatus.error));
    }
  }
}
