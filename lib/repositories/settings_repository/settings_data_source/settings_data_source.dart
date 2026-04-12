abstract class SettingsDataSource {
  Future<int> getReminderHour();
  Future<int> getReminderMinute();
  Future<void> setReminderTime(int hour, int minute);
  Future<bool> isReminderEnabled();
  Future<void> setReminderEnabled(bool enabled);
  Future<String> getThemeMode();
  Future<void> setThemeMode(String mode);
}
