import 'dart:async'; // for FutureOr
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/device_service.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../../../features/profile/presentation/providers/profile_provider.dart';
import '../../../../features/home/presentation/providers/home_provider.dart';
import '../../../../features/courses/presentation/providers/courses_provider.dart';
import 'package:flutter/foundation.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';

final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return getIt<AuthenticationRepository>();
});

final authControllerProvider =
    AsyncNotifierProvider.autoDispose<AuthController, void>(AuthController.new);

class AuthController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // nothing to initialize
  }

  Future<void> loginWithGoogle() async {
    final repository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.loginWithGoogle();

      // Force refresh user profile immediately so UI updates
      ref.invalidate(userProfileProvider);
      // Invalidate relevant user-dependent providers
      ref.invalidate(myCoursesProvider);
      ref.invalidate(cartProvider);
      ref.invalidate(homePopularCoursesProvider);
      ref.invalidate(homeCategoriesProvider);
      ref.invalidate(coursesProvider);
      // Wait for profile to load? No, let UI handle loading state via watch

      // Register device in background (don't await to speed up UI response)
      // This is not critical for the immediate user session
      getIt<DeviceService>()
          .registerDeviceIfChanged(force: true)
          .then((_) {})
          .catchError((_) {});
    });
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    // Do NOT set state = const AsyncLoading() here, because it triggers a rebuild
    // which might cause the widget to unmount while we are in the middle of operation.
    // The UI (ProfileScreen) handles the loading indicator locally.

    try {
      // 1. Attempt Server Logout
      try {
        await repository.logout();
      } catch (e) {
        debugPrint('Server logout failed (ignored): $e');
      }

      // 2. Clear Local Session (This is the critical part for sync UI)
      await repository.clearLocalSession();
    } catch (e) {
      debugPrint('Logout logic error: $e');
    } finally {
      await getIt<DeviceService>().clearDeviceInfo();

      // Invalidate providers to clear data
      ref.invalidate(userProfileProvider);
      ref.invalidate(myCoursesProvider);
      ref.invalidate(homeDataProvider);
      ref.invalidate(cartProvider);
      ref.invalidate(homePopularCoursesProvider);
      ref.invalidate(homeCategoriesProvider);
      ref.invalidate(coursesProvider);

      // We don't touch 'state' here to avoid triggering side effects in the UI
      // The local providers invalidation will naturally transition the UI to guest mode.
    }
  }
}
