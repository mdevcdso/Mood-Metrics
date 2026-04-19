import 'package:mood_metrics/models/journal_entry.dart';

abstract class JournalDataSource {
  Stream<List<JournalEntry>> watchEntries();

  Future<void> addEntry(JournalEntry entry);

  Future<void> updateEntry(JournalEntry entry);

  Future<void> deleteEntry(int id);
}
