part of 'journal_bloc.dart';

@immutable
sealed class JournalEvent {}

final class LoadJournalEntries extends JournalEvent {}

final class AddJournalEntry extends JournalEvent {
  final JournalEntry entry;

  AddJournalEntry({required this.entry});
}

final class DeleteJournalEntry extends JournalEvent {
  final int entryId;

  DeleteJournalEntry({required this.entryId});
}

final class UpdateJournalEntry extends JournalEvent {
  final JournalEntry entry;

  UpdateJournalEntry({required this.entry});
}
