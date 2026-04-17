import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_metrics/blocs/journal_bloc/journal_bloc.dart';
import 'package:mood_metrics/models/journal_entry.dart';
import 'package:mood_metrics/widgets/AddEntryDialog.dart';

import '../models/mood.dart';
import '../models/tag.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
          floatingActionButton: FloatingActionButton(
            onPressed: () => addEntryDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

Widget _buildBody(JournalState state) {
  if (state.status == JournalStatus.loading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (state.status == JournalStatus.error) {
    return const Center(child: Text('Erreur de chargement du journal'));
  }
  if (state.entries.isEmpty) {
    return const Center(child: Text('Aucune entrée de journal trouvée'));
  }
  return ListView.builder(
    itemCount: state.entries.length,
    itemBuilder: (context, index) {
      final entry = state.entries[index];
      return ListTile(
        title: Text(entry.mood.toString()),
        subtitle: Text(entry.date.toLocal().toString()),
      );
    },
  );
}
