import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mood_metrics/repositories/settings_repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({required this.settingsRepository}) : super(SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateReminderTime>(_onUpdateReminderTime);
    on<ToggleReminder>(_onToggleReminder);
    on<UpdateThemeMode>(_onUpdateThemeMode);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final hour = await settingsRepository.getReminderHour();
      final minute = await settingsRepository.getReminderMinute();
      final enabled = await settingsRepository.isReminderEnabled();
      final themeMode = await settingsRepository.getThemeMode();

      emit(
        SettingsState(
          status: SettingsStatus.loaded,
          reminderHour: hour,
          reminderMinute: minute,
          reminderEnabled: enabled,
          themeMode: themeMode,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: SettingsStatus.error));
    }
  }

  Future<void> _onUpdateReminderTime(
    UpdateReminderTime event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await settingsRepository.setReminderTime(event.hour, event.minute);
      emit(
        state.copyWith(
          reminderHour: event.hour,
          reminderMinute: event.minute,
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: SettingsStatus.error));
    }
  }

  Future<void> _onToggleReminder(
    ToggleReminder event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await settingsRepository.setReminderEnabled(event.enabled);
      emit(state.copyWith(reminderEnabled: event.enabled));
    } catch (error) {
      emit(state.copyWith(status: SettingsStatus.error));
    }
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await settingsRepository.setThemeMode(event.themeMode);
      emit(state.copyWith(themeMode: event.themeMode));
    } catch (error) {
      emit(state.copyWith(status: SettingsStatus.error));
    }
  }
}
