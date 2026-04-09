import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/firebase_messaging_service.dart';

import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/di/service_locator.dart';
import 'features/app_config/presentation/widgets/app_config_wrapper.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize dependency injection
  await setupServiceLocator();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();

    // Initialize Firebase Messaging (Request Permissions)
    await getIt<FirebaseMessagingService>().initialize();
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
}

/// Root application widget
class YunaApp extends ConsumerWidget {
  const YunaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Yuna',
      debugShowCheckedModeBanner: false,

      // Themes
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: themeMode, // Persisted theme from SharedPreferences
      // Router with AppConfig wrapper
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return AppConfigWrapper(
          key: const ValueKey('AppConfigWrapper'),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
