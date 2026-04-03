import 'package:flutter/material.dart';
import 'package:menstrudel/screens/dashboards/logs/widgets/tabs/logs_screen_insights_tab.dart';
import 'package:menstrudel/screens/dashboards/logs/widgets/tabs/logs_screen_log_tab.dart';
import 'package:menstrudel/screens/dashboards/logs/widgets/tabs/logs_screen_period_quick_view_tab.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:menstrudel/services/period_service.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final periodService = context.watch<PeriodService>();
    final userAge = context.watch<UserService>().age;

    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Column(
            children: [
              TabBar(
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: l10n.today),
                  Tab(text: l10n.logs),
                  Tab(text: l10n.insights),
                ],
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    LogsScreenPeriodQuickViewTab(periodService: periodService),
                    LogsScreenLogTab(periodService: periodService, userAge: userAge),
                    LogsScreenInsightsTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
