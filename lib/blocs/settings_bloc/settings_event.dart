part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

final class LoadSettings extends SettingsEvent {}

final class UpdateReminderTime extends SettingsEvent {
  final int hour;
  final int minute;

  UpdateReminderTime({required this.hour, required this.minute});
}

final class ToggleReminder extends SettingsEvent {
  final bool enabled;

  ToggleReminder({required this.enabled});
}

final class UpdateThemeMode extends SettingsEvent {
  final String themeMode;

  UpdateThemeMode({required this.themeMode});
}
