import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:menstrudel/database/repositories/sanitary_product_repository.dart';
import 'package:menstrudel/models/sanitary_products/sanitary_products_entry.dart';
import 'package:menstrudel/l10n/app_localizations.dart';
import 'package:menstrudel/services/notification_service.dart';
import 'package:menstrudel/widgets/sanitary_products/screen/sanitary_product_insights_tab.dart';
import 'package:menstrudel/widgets/sanitary_products/screen/sanitary_product_logs_tab.dart';
import 'package:menstrudel/controllers/log_sanitary_ui_controller.dart';

class SanitaryScreen extends StatefulWidget {
  const SanitaryScreen({super.key});

  @override
  State<SanitaryScreen> createState() => _SanitaryScreenState();
}

class _SanitaryScreenState extends State<SanitaryScreen> {
  List<SanitaryProductsEntry> _loggedSanitaryProducts = [];
  SanitaryProductsEntry? _activeEntry;
  bool _isLoading = true;
  final repo = SanitaryProductRepository();
  Timer? _uiTimer;
  LogSanitaryUIController? _controller;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Attach a listener to the controller provided by MainScreen
    final newController = context.read<LogSanitaryUIController>();
    if (_controller != newController) {
      _controller?.removeListener(_loadHistory);
      _controller = newController;
      _controller?.addListener(_loadHistory);
    }
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;
    setState(() { _isLoading = true; });
    
    final loadedEntries = await repo.getInactiveLogs();
    final activeEntry = await repo.getActiveEntry();

    if (!mounted) return;
    setState(() {
      _loggedSanitaryProducts = loadedEntries;
      _activeEntry = activeEntry;
      _isLoading = false;
    });

    // Handle Notifications based on current active state
    if (activeEntry != null) {
      final l10n = AppLocalizations.of(context)!;
      await NotificationService.cancelSanitaryProductReminder();
      if (activeEntry.reminderTime.isAfter(DateTime.now())) {
        await NotificationService.scheduleSanitaryProductReminder(
          reminderDateTime: activeEntry.reminderTime,
          title: l10n.notification_SanitaryProductReminderTitle,
          body: l10n.notification_SanitaryProductReminderBody,
        );
      }
    } else {
      await NotificationService.cancelSanitaryProductReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<LogSanitaryUIController>();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: l10n.logs),
              Tab(text: l10n.insights),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SanitaryProductLogsTab(
                  isLoading: _isLoading,
                  activeEntry: _activeEntry,
                  historyEntries: _loggedSanitaryProducts,
                  onCancelActive: () async {
                    await repo.deleteLog(_activeEntry!.id!);
                    _loadHistory();
                  },
                  onRemoveActive: () async {
                    await repo.markEntryAsRemoved(_activeEntry!.id!, DateTime.now());
                    _loadHistory();
                  },
                  onTapEntry: (entry) => controller.handleEditSanitaryLog(
                    context: context, 
                    entry: entry
                  ),
                ),
                SanitaryProductInsightsTab(
                  isLoading: _isLoading,
                  historyEntries: _loggedSanitaryProducts,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}