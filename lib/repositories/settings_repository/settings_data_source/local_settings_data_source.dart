import 'package:shared_preferences/shared_preferences.dart';
import 'package:mood_metrics/repositories/settings_repository/settings_data_source/settings_data_source.dart';

final class LocalSettingsDataSource extends SettingsDataSource {
  final SharedPreferences _prefs;

  LocalSettingsDataSource({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<int> getReminderHour() async {
    return _prefs.getInt('reminder_hour') ?? 9;
  }

  @override
  Future<int> getReminderMinute() async {
    return _prefs.getInt('reminder_minute') ?? 0;
  }

  @override
  Future<void> setReminderTime(int hour, int minute) async {
    await _prefs.setInt('reminder_hour', hour);
    await _prefs.setInt('reminder_minute', minute);
  }

  @override
  Future<bool> isReminderEnabled() async {
    return _prefs.getBool('reminder_enabled') ?? false;
  }

  @override
  Future<void> setReminderEnabled(bool enabled) async {
    await _prefs.setBool('reminder_enabled', enabled);
  }

  @override
  Future<String> getThemeMode() async {
    return _prefs.getString('theme_mode') ?? 'system';
  }

  @override
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString('theme_mode', mode);
  }
}
