import 'dart:developer';
import 'package:sparkbit/core/constants/app_routes.dart';
import 'package:sparkbit/router/app_router.dart';

/// Central service for handling notification navigation.
/// Works from both:
/// - Real-time FCM messages (no BuildContext available) — uses root router directly
/// - Notification list screen taps
///
/// Supported notification types:
///   general              → no navigation
///   course_update        → My Courses screen
///   new_lesson           → My Courses screen
///   order_status_changed → Order Detail screen (needs order_id)
class NotificationNavigator {
  NotificationNavigator._();

  static void navigate({
    required String? notificationType,
    required Map<String, dynamic>? data,
  }) {
    if (notificationType == null) return;

    final router = AppRouter.router;
    log('📬 [NotificationNavigator] type=$notificationType data=$data');

    switch (notificationType) {
      case 'course_update':
      case 'new_lesson':
        // Navigate to My Courses so user can see updated course
        router.go(AppRoutes.myCourses);
        break;

      case 'order_status_changed':
        final orderId = _parseInt(data?['order_id'] ?? data?['id']);
        if (orderId != null) {
          router.pushNamed(
            AppRoutes.orderDetailsName,
            pathParameters: {'id': orderId.toString()},
          );
        } else {
          // Fallback: open orders list
          router.push(AppRoutes.orders);
        }
        break;

      case 'general':
      default:
        log('📬 [NotificationNavigator] general — no navigation');
        break;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
