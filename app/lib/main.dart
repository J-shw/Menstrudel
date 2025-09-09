import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:dynamic_color/dynamic_color.dart';
import 'package:menstrudel/screens/main_screen.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:menstrudel/l10n/app_localizations.dart'; 
import 'package:menstrudel/utils/constants.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  tz_data.initializeTimeZones();
  try {
    final String localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone));
  } catch (e) {
    tz.setLocalLocation(tz.getLocation('Etc/UTC'));
  }
  
  await NotificationService.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSeed(seedColor: seedColor);
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,

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
          themeMode: ThemeMode.system,
          home: const MainScreen(),
        );
      },
    );
  }
}