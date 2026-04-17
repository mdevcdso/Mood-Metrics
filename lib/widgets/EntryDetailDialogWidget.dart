import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mood_metrics/blocs/journal_bloc/journal_bloc.dart';
import 'package:mood_metrics/models/journal_entry.dart';
import 'package:mood_metrics/models/mood.dart';
import 'package:mood_metrics/models/tag.dart';

void entryDetailDialog(BuildContext context, JournalEntry entry) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      Mood selectedMood = Mood.veryGood;
      String notes = '';
      List<Tag> selectedTags = [];

      return StatefulBuilder(
        builder: (_, setState) {
          return AlertDialog(
            title: Text(
              'Entrée du ${DateFormat('dd/MM/yyyy').format(entry.date)}',
            ),
            content: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mood de ce jour",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          entry.mood.label,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (entry.weight != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Votre poid a cette date",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        entry.notes,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                    if (entry.notes.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Note de la journée",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        entry.notes,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: entry.tags.map((tag) {
                        return Chip(label: Text(tag.label));
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => {
                },
                child: const Text('Supprimer'),
              ),
              ElevatedButton(
                onPressed: () {
                },
                child: const Text('Modifier'),
              ),
            ],
          );
        },
      );
    },
  );
}
