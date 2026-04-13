import 'settings_data_source/settings_data_source.dart';

final class SettingsRepository {
  final SettingsDataSource dataSource;

  const SettingsRepository({required this.dataSource});

  Future<int> getReminderHour() async {
    try {
      return await dataSource.getReminderHour();
    } catch (error) {
      rethrow;
    }
  }

  Future<int> getReminderMinute() async {
    try {
      return await dataSource.getReminderMinute();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> setReminderTime(int hour, int minute) async {
    try {
      await dataSource.setReminderTime(hour, minute);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> isReminderEnabled() async {
    try {
      return await dataSource.isReminderEnabled();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> setReminderEnabled(bool enabled) async {
    try {
      await dataSource.setReminderEnabled(enabled);
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getThemeMode() async {
    try {
      return await dataSource.getThemeMode();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> setThemeMode(String mode) async {
    try {
      await dataSource.setThemeMode(mode);
    } catch (error) {
      rethrow;
    }
  }
}
