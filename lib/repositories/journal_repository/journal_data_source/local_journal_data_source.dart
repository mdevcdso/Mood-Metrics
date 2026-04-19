import 'dart:async';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../../database/database_helper.dart';
import '../../../models/journal_entry.dart';
import '../../../models/mood.dart';
import '../../../models/tag.dart';
import 'journal_data_source.dart';

final class LocalJournalDataSource extends JournalDataSource {
  final _controller = StreamController<List<JournalEntry>>.broadcast();

  Future<Database> get _db => DatabaseHelper.database;

  Future<void> _emitEntries() async {
    final db = await _db;
    final maps = await db.query('journal_entries', orderBy: 'date DESC');
    final entries = maps
        .map(
          (m) => JournalEntry(
            id: m['id'] as int,
            date: DateFormat('dd/MM/yyyy').parse(m['date'] as String),
            mood: Mood.values[m['mood'] as int],
            weight: m['weight'] as double?,
            notes: m['notes'] as String,
            tags: (m['tags'] as String)
                .split(',')
                .where((tag) => tag.isNotEmpty)
                .map((tag) => Tag.values.byName(tag.trim()))
                .toList(),
          ),
        )
        .toList();
    _controller.add(entries);
  }

  @override
  Stream<List<JournalEntry>> watchEntries() {
    _emitEntries();
    return _controller.stream;
  }

  @override
  Future<void> addEntry(JournalEntry entry) async {
    final db = await _db;
    String formatted = DateFormat('dd/MM/yyyy').format(entry.date);
    await db.insert('journal_entries', {
      'date': formatted,
      'mood': entry.mood.index,
      'weight': entry.weight,
      'notes': entry.notes,
      'tags': entry.tags.map((t) => t.name).join(','),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await _emitEntries();
  }

  @override
  Future<void> deleteEntry(int entryId) async {
    final db = await _db;
    await db.delete('journal_entries', where: 'id = ?', whereArgs: [entryId]);
    await _emitEntries();
  }

  @override
  Future<void> updateEntry(JournalEntry entry) async {
    final db = await _db;
    String formatted = DateFormat('dd/MM/yyyy').format(entry.date);
    await db.update(
      'journal_entries',
      {
        'date': formatted,
        'mood': entry.mood.index,
        'weight': entry.weight,
        'notes': entry.notes,
        'tags': entry.tags.map((t) => t.name).join(','),
      },
      where: 'id = ?',
      whereArgs: [entry.id],
    );
    await _emitEntries();
  }
}
