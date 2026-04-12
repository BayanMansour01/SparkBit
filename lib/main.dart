import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/firebase_messaging_service.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/di/service_locator.dart';
import 'features/app_config/presentation/widgets/app_config_wrapper.dart';
import 'router/app_router.dart';
import 'core/security/security_checker.dart';
import 'core/security/emulator_blocked_screen.dart';

Future<void> _initializeFirebaseMessagingInBackground() async {
  try {
    await getIt<FirebaseMessagingService>().initialize().timeout(
      const Duration(seconds: 8),
    );
  } catch (e) {
    debugPrint('FCM initialization failed/skipped: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ═══════════════════════════════════════════════════════════════
  // 🛡️ SECURITY: Emulator Detection (blocking — runs first)
  // ═══════════════════════════════════════════════════════════════

  try {
    final emulatorReason = await SecurityChecker.checkIfEmulator().timeout(
      const Duration(seconds: 5),
      onTimeout: () => null,
    );

    if (emulatorReason != null) {
      final deviceInfo = await SecurityChecker.getDeviceInfoString();
      debugPrint('🛡️ BLOCKED: Emulator detected — $emulatorReason');
      runApp(
        EmulatorBlockedScreen(reason: emulatorReason, deviceInfo: deviceInfo),
      );
      return; // Stop here — don't initialize the rest of the app
    }
  } catch (e) {
    debugPrint('🛡️ Security: Emulator check error (ignored): $e');
  }

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize dependency injection
  await setupServiceLocator();

  // Initialize Firebase
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 8));
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        // Override sharedPreferencesProvider with the actual instance
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const YunaApp(),
    ),
  );

  // Never block app startup on push initialization.
  unawaited(_initializeFirebaseMessagingInBackground());
}

/// Root application widget
class YunaApp extends ConsumerWidget {
  const YunaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Sparkbit',
      debugShowCheckedModeBanner: false,

      // Themes
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: themeMode, // Persisted theme from SharedPreferences
      // Router with AppConfig wrapper
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      backButtonDispatcher: AppRouter.backButtonDispatcher,
      builder: (context, child) {
        return AppConfigWrapper(
          key: const ValueKey('AppConfigWrapper'),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
