part of 'journal_bloc.dart';

enum JournalStatus { initial, loading, loaded, error }

final class JournalState {
  final JournalStatus status;
  final List<JournalEntry> entries;

  JournalState({this.status = JournalStatus.initial, this.entries = const []});

  JournalState copyWith({JournalStatus? status, List<JournalEntry>? entries}) {
    return JournalState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
    );
  }
}
