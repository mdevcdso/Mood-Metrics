
import '../../../models/journal_entry.dart';
import 'journal_data_source.dart';

final class LocalJournalDataSource extends JournalDataSource {
  final List<JournalEntry> _entries = [];

  LocalJournalDataSource({required List<JournalEntry> initialEntries}) {
    _entries.addAll(initialEntries);
  }

  @override
  Future<void> addEntry(JournalEntry entry) async {
    _entries.add(entry);
  }

  @override
  Future<void> deleteEntry(int entryId) async {
    _entries.removeWhere((entry) => entry.id == entryId);
  }

  @override
  Stream<List<JournalEntry>> watchEntries() {
    return Stream.value(List.unmodifiable(_entries));
  }

  @override
  Future<void> updateEntry(JournalEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  @override
  Future<JournalEntry?> getEntryByDate(DateTime date) {
    // TODO: implement getEntryByDate
    throw UnimplementedError();
  }

}