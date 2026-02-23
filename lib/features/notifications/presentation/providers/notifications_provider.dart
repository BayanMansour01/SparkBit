import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/models/paginated_data.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  return getIt<NotificationsRepository>();
});

final notificationsProvider = FutureProvider.autoDispose
    .family<PaginatedData<NotificationModel>, int>((ref, page) {
      final repository = ref.watch(notificationsRepositoryProvider);
      return repository.getNotifications(page: page);
    });

final unreadNotificationsCountProvider = FutureProvider.autoDispose<int>((
  ref,
) async {
  // Keep alive to prevent re-fetching on navigation
  ref.keepAlive();

  try {
    final repository = ref.watch(notificationsRepositoryProvider);
    final count = await repository.getUnreadCount();
    debugPrint('✅ Unread count provider: Successfully got count = $count');
    return count;
  } catch (e, stackTrace) {
    debugPrint('❌ Unread count provider error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
});
