import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_metrics/blocs/journal_bloc/journal_bloc.dart';
import 'package:mood_metrics/repositories/journal_repository/JournalRepository.dart';
import 'package:mood_metrics/repositories/journal_repository/journal_data_source/local_journal_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mood_metrics/blocs/settings_bloc/settings_bloc.dart';
import 'package:mood_metrics/repositories/settings_repository/settings_repository.dart';
import 'package:mood_metrics/repositories/settings_repository/settings_data_source/local_settings_data_source.dart';
import 'package:mood_metrics/screens/home_screen.dart';
import 'package:mood_metrics/services/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final notificationService = NotificationsService();
  await notificationService.init();
  runApp(MyApp(prefs: prefs, notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final NotificationsService notificationService;

  const MyApp({
    super.key,
    required this.prefs,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsBloc(
            settingsRepository: SettingsRepository(
              dataSource: LocalSettingsDataSource(prefs: prefs),
            ),
            notificationService: notificationService,
          )..add(LoadSettings()),
        ),
        BlocProvider(
          create: (context) => JournalBloc(
            journalRepository: JournalRepository(
              dataSource: LocalJournalDataSource(),
            ),
          )..add(LoadJournalEntries()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mood & Metrics',
            themeMode: _getThemeMode(state.themeMode),
            theme: ThemeData(
              colorSchemeSeed: Colors.deepPurple,
              useMaterial3: true,
              appBarTheme: const AppBarTheme(centerTitle: true),
            ),
            darkTheme: ThemeData(
              colorSchemeSeed: Colors.deepPurple,
              useMaterial3: true,
              brightness: Brightness.dark,
              appBarTheme: const AppBarTheme(centerTitle: true),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
