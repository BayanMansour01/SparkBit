import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sparkbit/core/services/notification_navigator.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('✅ FCM: User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('⚠️ FCM: User granted provisional permission');
    } else {
      log('❌ FCM: User declined or has not accepted permission');
    }

    // Subscribe in background so startup does not wait on network.
    unawaited(subscribeToTopic('general'));

    // ─────────────────────────────────────────────────────────────
    // FOREGROUND: App is open — message arrives but no system tray notification
    // We handle navigation manually here
    // ─────────────────────────────────────────────────────────────
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(
        '📬 FCM [Foreground] title=${message.notification?.title} data=${message.data}',
      );
      // Foreground: do NOT auto-navigate. The MainWrapper shows an in-app banner.
      // User taps the banner to navigate manually.
    });

    // ─────────────────────────────────────────────────────────────
    // BACKGROUND → FOREGROUND: User tapped the notification from system tray
    // ─────────────────────────────────────────────────────────────
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(
        '📬 FCM [Background→Foreground] title=${message.notification?.title} data=${message.data}',
      );
      _handleNavigation(message.data);
    });

    // ─────────────────────────────────────────────────────────────
    // TERMINATED: App was closed — user tapped notification to open app
    // ─────────────────────────────────────────────────────────────
    RemoteMessage? initialMessage;
    try {
      initialMessage = await _firebaseMessaging.getInitialMessage().timeout(
        const Duration(seconds: 3),
        onTimeout: () => null,
      );
    } catch (e) {
      log('❌ FCM initial message check failed: $e');
    }
    final terminatedMessage = initialMessage;
    if (terminatedMessage != null) {
      log(
        '📬 FCM [Terminated] title=${terminatedMessage.notification?.title} data=${terminatedMessage.data}',
      );
      // Small delay to ensure router is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNavigation(terminatedMessage.data);
      });
    }
  }

  /// Delegates navigation to the central NotificationNavigator
  void _handleNavigation(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    NotificationNavigator.navigate(notificationType: type, data: data);
  }

  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      log('🔑 FCM Token: $token');
      return token;
    } catch (e) {
      log('❌ Error getting FCM token: $e');
      return null;
    }
  }

  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      log('📡 Subscribed to topic: $topic');
    } catch (e) {
      log('❌ Error subscribing to topic $topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('📡 Unsubscribed from topic: $topic');
    } catch (e) {
      log('❌ Error unsubscribing from topic $topic: $e');
    }
  }
}
