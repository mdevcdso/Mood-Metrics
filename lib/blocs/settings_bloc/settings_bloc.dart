import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mood_metrics/repositories/settings_repository/settings_repository.dart';
import 'package:mood_metrics/services/notifications_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  final NotificationsService notificationService;

  SettingsBloc({
    required this.settingsRepository,
    required this.notificationService,
  }) : super(SettingsState()) {
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

      if (enabled) {
        await notificationService.scheduleDailyReminder(hour, minute);
      }

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
      if (state.reminderEnabled) {
        await notificationService.cancelAllNotifs();
        await notificationService.scheduleDailyReminder(event.hour, event.minute);
      }
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
      if (event.enabled) {
        await notificationService.requestPermission();
        await notificationService.scheduleDailyReminder(
          state.reminderHour,
          state.reminderMinute,
        );
      } else {
        await notificationService.cancelAllNotifs();
      }
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
