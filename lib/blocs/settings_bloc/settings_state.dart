part of 'settings_bloc.dart';

enum SettingsStatus {
  initial,
  loading,
  loaded,
  error,
}

final class SettingsState {
  final SettingsStatus status;
  final int reminderHour;
  final int reminderMinute;
  final bool reminderEnabled;
  final String themeMode;

  SettingsState({
    this.status = SettingsStatus.initial,
    this.reminderHour = 9,
    this.reminderMinute = 0,
    this.reminderEnabled = false,
    this.themeMode = 'system',
  });

  SettingsState copyWith({
    SettingsStatus? status,
    int? reminderHour,
    int? reminderMinute,
    bool? reminderEnabled,
    String? themeMode,
  }) {
    return SettingsState(
      status: status ?? this.status,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
