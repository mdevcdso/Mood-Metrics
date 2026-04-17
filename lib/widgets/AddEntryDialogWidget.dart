import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_metrics/blocs/journal_bloc/journal_bloc.dart';
import 'package:mood_metrics/models/journal_entry.dart';
import 'package:mood_metrics/models/mood.dart';
import 'package:mood_metrics/models/tag.dart';

void addEntryDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      Mood selectedMood = Mood.veryGood;
      String notes = '';
      List<Tag> selectedTags = [];

      return StatefulBuilder(
        builder: (_, setState) {
          return AlertDialog(
            title: const Text('Nouvelle entrée'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Mood>(
                    value: selectedMood,
                    decoration: const InputDecoration(labelText: 'Humeur'),
                    items: Mood.values.map((mood) {
                      return DropdownMenuItem(
                        value: mood,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(mood.value.toString()),
                            Text(mood.label),
                          ],
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: (context) => Mood.values
                        .map((mood) => Text(mood.label))
                        .toList(),
                    onChanged: (value) => setState(() => selectedMood = value!),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Notes (optionel)'),
                    onChanged: (value) => notes = value,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Poids (optionel)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final intValue = int.tryParse(value);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 8,
                      children: Tag.values.map((tag) {
                        return FilterChip(
                          label: Text(tag.label),
                          selected: selectedTags.contains(tag),
                          onSelected: (selected) {
                            setState(() {
                              selected
                                  ? selectedTags.add(tag)
                                  : selectedTags.remove(tag);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  JournalEntry newEntry = JournalEntry(
                    date: DateTime.now(), //.subtract(Duration(days: 8)),
                    mood: selectedMood,
                    notes: notes,
                    tags: selectedTags,
                  );
                  context.read<JournalBloc>().add(
                    AddJournalEntry(entry: newEntry),
                  );
                  Navigator.pop(dialogContext);
                },
                child: const Text('Ajouter'),
              ),
            ],
          );
        },
      );
    },
  );
}
