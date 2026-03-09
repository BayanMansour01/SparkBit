import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../resources/values_manager.dart';
import 'app_update_listener.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';
import '../../features/courses/presentation/providers/courses_provider.dart';
import '../../features/home/presentation/providers/home_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/snackbar_utils.dart';

class MainWrapper extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupNotificationListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh course progress data when user returns to the app
      ref.read(myCoursesProvider.notifier).refreshData();
      ref.read(coursesProvider.notifier).refreshData();
      ref.invalidate(homeDataProvider);
      ref.invalidate(homePopularCoursesProvider);
    }
  }

  void _setupNotificationListeners() {
    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('🔔 Foreground Notification: ${message.notification?.title}');
      debugPrint('🔔 Payload: ${message.data}');
      if (mounted) {
        // Invalidate the provider to refetch the unread count from server
        debugPrint('🔔 Invalidating unread count provider...');
        ref.invalidate(unreadNotificationsCountProvider);

        // Force immediate refresh by reading the provider
        ref.read(unreadNotificationsCountProvider);

        // Handle order status changed notifications
        final type = message.data['notification_type'] ?? message.data['type'];
        if (type == 'order_status_changed') {
          debugPrint('🔔 Order status changed, refreshing orders...');
          ref.invalidate(ordersProvider);

          // Check if order was approved to refresh courses
          final orderStatus = message.data['order_status'];
          if (orderStatus == 'approved') {
            debugPrint('🔔 Order approved, refreshing courses and home...');
            ref.invalidate(myCoursesProvider);
            ref.invalidate(coursesProvider);
            ref.invalidate(homeDataProvider);
            ref.invalidate(homePopularCoursesProvider);
            ref.invalidate(homeCategoriesProvider);
          }
        }

        // Show interactive snackbar for real-time navigation
        if (message.notification != null) {
          AppSnackBar.showNotification(
            context,
            title: message.notification?.title ?? 'New Notification',
            body: message.notification?.body ?? '',
            onTap: () => _handleNotificationNavigation(message.data),
          );
        }
      }
    });

    // Handle notification tap when app is in background but still running
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('🔔 Notification Tapped (Background): ${message.data}');

      // Refresh orders if it's an order status changed notification
      final type = message.data['notification_type'] ?? message.data['type'];
      if (type == 'order_status_changed') {
        debugPrint('🔔 Order status changed, refreshing orders...');
        ref.invalidate(ordersProvider);

        // Check if order was approved to refresh courses
        final orderStatus = message.data['order_status'];
        if (orderStatus == 'approved') {
          debugPrint('🔔 Order approved, refreshing courses and home...');
          ref.invalidate(myCoursesProvider);
          ref.invalidate(coursesProvider);
          ref.invalidate(homeDataProvider);
          ref.invalidate(homePopularCoursesProvider);
          ref.invalidate(homeCategoriesProvider);
        }
      }

      _handleNotificationNavigation(message.data);
    });

    // Check if app was opened from a terminated state via a notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint('🔔 Notification Tapped (Terminated): ${message.data}');

        // Refresh orders if it's an order status changed notification
        final type = message.data['notification_type'] ?? message.data['type'];
        if (type == 'order_status_changed') {
          debugPrint('🔔 Order status changed, refreshing orders...');
          ref.invalidate(ordersProvider);

          // Check if order was approved to refresh courses
          final orderStatus = message.data['order_status'];
          if (orderStatus == 'approved') {
            debugPrint('🔔 Order approved, refreshing courses and home...');
            ref.invalidate(myCoursesProvider);
            ref.invalidate(coursesProvider);
            ref.invalidate(homeDataProvider);
            ref.invalidate(homePopularCoursesProvider);
            ref.invalidate(homeCategoriesProvider);
          }
        }

        _handleNotificationNavigation(message.data);
      }
    });
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final type = data['notification_type'] ?? data['type'];
    if (type == null) return;

    switch (type) {
      case 'order':
      case 'purchase':
      case 'order_status_changed':
        final orderId = data['order_id'] ?? data['id'];
        if (orderId != null) {
          context.pushNamed(
            AppRoutes.orderDetailsName,
            pathParameters: {'id': orderId.toString()},
          );
        } else {
          // No specific order ID, go to orders list
          context.push(AppRoutes.orders);
        }
        break;
      case 'course':
        // Navigation to course details requires a full model currently
        // This might need a separate route fetching logic later
        break;
      case 'notification':
        context.push(AppRoutes.notifications);
        break;
    }
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final isGuest = profile?.id == -1;

    return AppUpdateListener(
      child: Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: _CustomBottomNavBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: (index) => _onTap(context, index),
          isGuest: isGuest,
        ),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isGuest;

  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we are in landscape or use a safe area bottom padding
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppPadding.p20,
        0,
        AppPadding.p20,
        bottomPadding +
            AppPadding.p20, // Add bottom padding for "floating" look
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius:
                  25, // No specialized constant for shadowBlur25 in AppRadius, kept raw or added to AppSize? I added AppSize.s25 in values_manager
              offset: const Offset(0, 10), // AppSize.s10
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p24,
                vertical: AppPadding.p6,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainer.withOpacity(0.95),
                borderRadius: BorderRadius.circular(AppRadius.r40),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavBarItem(
                    icon: Icons.home_rounded,
                    isActive: currentIndex == 0,
                    label: 'Home',
                    onTap: () => onTap(0),
                  ),
                  _NavBarItem(
                    icon: isGuest
                        ? Icons.explore_rounded
                        : Icons.school_rounded,
                    isActive: currentIndex == 1,
                    label: isGuest ? 'Browse' : 'My Courses',
                    onTap: () => onTap(1),
                  ),

                  _NavBarItem(
                    icon: Icons.person_rounded,
                    isActive: currentIndex == 2, // Shifted index
                    label: 'Profile',
                    onTap: () => onTap(2), // Shifted index
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final String label;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isActive,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? AppPadding.p20 : AppPadding.p12,
          vertical: AppPadding.p12,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: AppSize.s20,
            ),
            if (isActive) ...[
              const SizedBox(width: AppSize.s8),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13, // fontSm
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
