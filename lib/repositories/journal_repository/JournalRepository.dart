import 'package:mood_metrics/models/journal_entry.dart';
import 'journal_data_source/journal_data_source.dart';

final class JournalRepository {
  final JournalDataSource dataSource;

  const JournalRepository({required this.dataSource});

  Stream<List<JournalEntry>> watchEntries() {
    try {
      return dataSource.watchEntries();
    } catch (error) {
      rethrow;
    }
  }

  Future<JournalEntry?> getEntryByDate(DateTime date) async {
    try {
      return await dataSource.getEntryByDate(date);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addEntry(JournalEntry entry) async {
    try {
      await dataSource.addEntry(entry);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateEntry(JournalEntry entry) async {
    try {
      await dataSource.updateEntry(entry);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteEntry(int id) async {
    try {
      await dataSource.deleteEntry(id);
    } catch (error) {
      rethrow;
    }
  }
}
