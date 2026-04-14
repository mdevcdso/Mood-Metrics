import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_metrics/blocs/settings_bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state.status == SettingsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == SettingsStatus.error) {
          return const Center(child: Text('Erreur de chargement des paramètres'));
        }

        return ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Rappel quotidien',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Activer le rappel'),
              subtitle: const Text('Recevoir une notification chaque jour'),
              value: state.reminderEnabled,
              onChanged: (value) {
                context.read<SettingsBloc>().add(
                  ToggleReminder(enabled: value),
                );
              },
            ),
            ListTile(
              title: const Text('Heure du rappel'),
              subtitle: Text(
                '${state.reminderHour.toString().padLeft(2, '0')}:${state.reminderMinute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.access_time),
              enabled: state.reminderEnabled,
              onTap: state.reminderEnabled
                  ? () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: state.reminderHour,
                          minute: state.reminderMinute,
                        ),
                      );
                      if (time != null && context.mounted) {
                        context.read<SettingsBloc>().add(
                          UpdateReminderTime(
                            hour: time.hour,
                            minute: time.minute,
                          ),
                        );
                      }
                    }
                  : null,
            ),
            const Divider(),
            ListTile(
              title: const Text('Tester les notifications'),
              leading: const Icon(Icons.notifications_active),
              onTap: () {
                context.read<SettingsBloc>().notificationService.showTestNotification();
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Apparence',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'system',
                    label: Text('Système'),
                    icon: Icon(Icons.phone_android),
                  ),
                  ButtonSegment(
                    value: 'light',
                    label: Text('Clair'),
                    icon: Icon(Icons.light_mode),
                  ),
                  ButtonSegment(
                    value: 'dark',
                    label: Text('Sombre'),
                    icon: Icon(Icons.dark_mode),
                  ),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (selected) {
                  context.read<SettingsBloc>().add(
                    UpdateThemeMode(themeMode: selected.first),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
