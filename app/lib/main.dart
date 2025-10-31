import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:menstrudel/l10n/app_localizations.dart'; 
import 'package:menstrudel/notifiers/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/services/wear_sync_service.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';
import 'package:menstrudel/screens/auth_gate.dart';
import 'package:menstrudel/notifiers/locale_notifier.dart';
import 'package:menstrudel/services/settings_service.dart';

final watchService = WatchSyncService();
final periodsRepository = PeriodsRepository();

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  tz_data.initializeTimeZones();
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('Etc/UTC'));
  }
  
  await NotificationService.initialize();

  final settingsService = SettingsService();
  await settingsService.loadSettings();

  watchService.initialize(
    onPeriodLog: periodsRepository.logPeriodFromWatch,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => settingsService,
        ),  
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(
            context.read<SettingsService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LocaleNotifier(
            context.read<SettingsService>(),
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final localeNotifier = context.watch<LocaleNotifier>();

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;
        
        final bool useDynamicTheme = themeNotifier.isDynamicEnabled;

        if (useDynamicTheme && lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          final Color seed = themeNotifier.themeColor;
          
          lightColorScheme = ColorScheme.fromSeed(seedColor: seed);
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: seed,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          locale: localeNotifier.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (context) {
            return AppLocalizations.of(context)!.appTitle;
          },
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          themeMode: themeNotifier.themeMode.getThemeMode(),
          home: const AuthGate(),
        );
      },
    );
  }
}