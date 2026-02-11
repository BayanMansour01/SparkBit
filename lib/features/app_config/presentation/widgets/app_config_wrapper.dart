import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_config_provider.dart';
import '../screens/maintenance_screen.dart';
import '../screens/update_required_screen.dart';

/// Wrapper widget that checks app config before showing the app
class AppConfigWrapper extends ConsumerWidget {
  final Widget child;

  const AppConfigWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfigAsync = ref.watch(appConfigProvider);
    final currentVersionAsync = ref.watch(currentAppVersionProvider);
    final maintenanceModeAsync = ref.watch(maintenanceModeProvider);
    final updateRequiredAsync = ref.watch(updateRequiredProvider);

    return appConfigAsync.when(
      data: (config) {
        // Check maintenance mode first
        if (maintenanceModeAsync.value == true) {
          return MaintenanceScreen(message: config.maintenanceMessage);
        }

        // Check if update is required
        if (updateRequiredAsync.value == true &&
            currentVersionAsync.value != null) {
          return UpdateRequiredScreen(
            message: config.updateMessage,
            currentVersion: currentVersionAsync.value!,
            latestVersion: config.minVersion,
            androidUrl: config.androidUrl,
            iosUrl: config.iosUrl,
          );
        }

        // All checks passed, show the app
        return child;
      },
      loading: () => child,
      error: (error, stack) {
        // On error, show the app (fail-safe)
        return child;
      },
    );
  }
}
