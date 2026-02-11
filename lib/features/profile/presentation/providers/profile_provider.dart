import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/mock_data.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../../../core/services/firebase_messaging_service.dart';

/// Provider for ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return getIt<ProfileRepository>();
});

/// Provider for GetProfileUseCase
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repository);
});

/// Provider for UpdateProfileUseCase
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateProfileUseCase(repository);
});

/// Notifier for managing profile state and updates
class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    // Keep alive to ensure profile data persists and isn't re-fetched unnecessarily
    ref.keepAlive();

    final prefs = getIt<SharedPreferences>();
    final token = prefs.getString('access_token');
    log(token.toString());
    if (token == null || token.isEmpty) {
      return MockData.guestProfile;
    }

    try {
      final useCase = ref.watch(getProfileUseCaseProvider);
      final profile = await useCase();

      // Sync FCM Topics (Smart Diffing)
      await _syncFcmTopics(profile.fcmTopics);

      return profile;
    } catch (e) {
      // Don't silently return mock profile on error!
      // Re-throw the error so the UI can show proper error state.
      // The user will see an error message and can retry.
      rethrow;
    }
  }

  /// Syncs FCM topics by comparing with locally cached topics
  Future<void> _syncFcmTopics(List<String>? newTopicsList) async {
    final prefs = getIt<SharedPreferences>();
    final fcmService = getIt<FirebaseMessagingService>();
    const String cacheKey = 'cached_fcm_topics';

    // 1. Get currently cached topics
    final Set<String> cachedTopics =
        prefs.getStringList(cacheKey)?.toSet() ?? {};

    // 2. Get new topics from API
    final Set<String> newTopics = newTopicsList?.toSet() ?? {};

    // DBG: Log current state
    // DBG: Log current state
    // Note: Ensure dart:developer is imported at the top
    // log('FCM Sync: Cached=$cachedTopics, New=$newTopics');
    // I will enable log after fixing import.
    print('FCM Sync: Cached=$cachedTopics, New=$newTopics');

    // 3. Calculate Diff
    final Set<String> topicsToSubscribe = newTopics.difference(cachedTopics);
    final Set<String> topicsToUnsubscribe = cachedTopics.difference(newTopics);

    // 4. Perform Actions
    if (topicsToSubscribe.isEmpty && topicsToUnsubscribe.isEmpty) {
      print('FCM Sync: No changes needed.');
      return;
    }

    print(
      'FCM Sync: Subscribing to $topicsToSubscribe, Unsubscribing from $topicsToUnsubscribe',
    );

    // Subscribe to new topics
    for (final topic in topicsToSubscribe) {
      await fcmService.subscribeToTopic(topic);
    }

    // Unsubscribe from removed topics
    for (final topic in topicsToUnsubscribe) {
      await fcmService.unsubscribeFromTopic(topic);
    }

    // 5. Update Cache
    await prefs.setStringList(cacheKey, newTopics.toList());
    print('FCM Sync: Cache updated.');
  }

  Future<void> updateProfileName(String name) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(updateProfileUseCaseProvider);
      final updatedProfile = await useCase(name, null);
      state = AsyncValue.data(updatedProfile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(String? name, [String? avatarPath]) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(updateProfileUseCaseProvider);
      final updatedProfile = await useCase(name, avatarPath);
      state = AsyncValue.data(updatedProfile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for profile state
final userProfileProvider = AsyncNotifierProvider<ProfileNotifier, UserProfile>(
  ProfileNotifier.new,
);
