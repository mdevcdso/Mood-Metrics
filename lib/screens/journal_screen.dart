import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mood_metrics/blocs/journal_bloc/journal_bloc.dart';
import 'package:mood_metrics/models/journal_entry.dart';
import 'package:mood_metrics/widgets/AddEntryDialogWidget.dart';
import 'package:mood_metrics/widgets/JournalEntryCardWidget.dart';

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
            onPressed: () => addEntryDialog(context, DateTime.now()), //.subtract(Duration(days: 1))),
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
  return MasonryGridView.count(
    crossAxisCount: 2,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    itemCount: state.entries.length,
    itemBuilder: (context, index) {
      return JournalEntryCardWidget(
        entry: state.entries[index],
      );
    },
  );
}
