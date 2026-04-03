import 'package:flutter/material.dart';
import 'package:menstrudel/controllers/log_reversible_contraceptive_ui_controller.dart';
import 'package:menstrudel/controllers/log_sanitary_ui_controller.dart';
import 'package:menstrudel/controllers/log_sex_ui_controller.dart';
import 'package:menstrudel/controllers/log_ui_controller.dart';
import 'package:menstrudel/coordinators/data_refresh_coordinator.dart';
import 'package:menstrudel/database/repositories/periods_repository.dart';
import 'package:menstrudel/database/repositories/logs_repository.dart';
import 'package:menstrudel/database/repositories/user_repository.dart';
import 'package:menstrudel/screens/gates/root_gate.dart';
import 'package:menstrudel/services/symptom_service.dart';
import 'package:menstrudel/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/notifiers/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/services/wear_sync_service.dart';
import 'package:menstrudel/models/themes/app_theme_mode_enum.dart';
import 'package:menstrudel/notifiers/locale_notifier.dart';
import 'package:menstrudel/services/settings_service.dart';
import 'package:home_widget/home_widget.dart';
import 'package:menstrudel/services/widget_controller.dart';
import 'package:menstrudel/services/period_service.dart';
import 'package:menstrudel/services/log_service.dart';

final watchService = WatchSyncService();
final logsRepository = LogsRepository();

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

  final SharedPreferences sharedPrefrences = await SharedPreferences.getInstance();
  final SettingsService settingsService = SettingsService(sharedPrefrences);
  final UserService userService = UserService(UserRepository());
  final SymptomService symptomService = SymptomService(sharedPrefrences);

  watchService.initialize(onPeriodLog: logsRepository.logFromWatch);

  runApp(
    MultiProvider(
      providers: [
        // --- Core services ---
        ChangeNotifierProvider(create: (_) => settingsService),
        ChangeNotifierProvider(create: (_) => userService),
        ChangeNotifierProvider(create: (_) => symptomService),

        // --- Repositories ---
        Provider(create: (_) => LogsRepository()),
        Provider(create: (_) => PeriodsRepository()),

        // --- UI state ---
        ChangeNotifierProvider(
          create: (context) => ThemeNotifier(context.read<SettingsService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => LocaleNotifier(context.read<SettingsService>()),
        ),

        // --- Integrations ---
        Provider(create: (_) => WidgetController()),

        // --- Domain services ---
        ChangeNotifierProvider(
          create: (context) => LogService(context.read<LogsRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => PeriodService(
            context.read<SettingsService>(),
            context.read<PeriodsRepository>(),
          ),
        ),
        Provider(
          create: (context) => DataRefreshCoordinator(
            logService: context.read<LogService>(),
            periodService: context.read<PeriodService>(),
            widgetController: context.read<WidgetController>(),
          ),
        ),

        // --- Controllers ---
        ChangeNotifierProvider(create: (_) => LogUIController()),
        ChangeNotifierProvider(create: (_) => LogSanitaryUIController()),
        ChangeNotifierProvider(create: (_) => LogSexUIController()),
        ChangeNotifierProvider(create: (_) => LogReversibleContraceptiveUIController())
      ],
      child: const MainApp(),
    ),
  );

}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleWidgetLaunch);
    HomeWidget.widgetClicked.listen(_handleWidgetLaunch);
  }

  void _handleWidgetLaunch(Uri? uri) {
    if (uri != null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('App Launched from Widget'),
            content: Text('URI: $uri'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

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
          builder: (context, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final l10n = AppLocalizations.of(context);
              if (l10n != null) {
                context.read<DataRefreshCoordinator>().registerL10n(l10n);
              }
            });
            return child!;
          },
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          themeMode: themeNotifier.themeMode.getThemeMode(),
          home: const RootGate(),
        );
      },
    );
  }
}