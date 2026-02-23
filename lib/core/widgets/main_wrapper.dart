import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_strings.dart';
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

class _MainWrapperState extends ConsumerState<MainWrapper> {
  static const platform = MethodChannel('com.example.yuna/back_button');

  @override
  void initState() {
    super.initState();
    _setupBackButtonHandler();
    _setupNotificationListeners();
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

  void _setupBackButtonHandler() {
    platform.setMethodCallHandler((call) async {
      debugPrint('🔙 Native back button pressed via MethodChannel!');

      if (call.method == 'onBackPressed') {
        // Show exit dialog
        final shouldExit = await _handleBackPress();
        debugPrint('🔙 Returning $shouldExit to native code');

        // Return true to allow native back, false to prevent it
        return shouldExit;
      }

      return false;
    });
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Future<bool> _handleBackPress() async {
    final rootNavigator = Navigator.of(context, rootNavigator: true);

    // If we have a screen pushed on top of the root navigator (like OrdersScreen),
    // pop that screen and tell native code we handled it (return false).
    if (rootNavigator.canPop()) {
      debugPrint('🔙 Sub-page active, popping screen');
      rootNavigator.pop();
      return false; // Handled in Flutter
    }

    debugPrint('🔙 Root page active, showing exit dialog...');

    // Always show exit dialog on back button at root
    final shouldExit = await _showExitDialog(context);
    debugPrint('🔙 User chose to exit: $shouldExit');

    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final isGuest = profile?.id == -1;

    return AppUpdateListener(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          debugPrint('🔙 PopScope called (fallback) - didPop: $didPop');

          if (didPop) {
            debugPrint('🔙 Already handled');
            return;
          }

          // Fallback: Handle back button press if MethodChannel didn't catch it
          final shouldExit = await _handleBackPress();
          if (shouldExit && context.mounted) {
            SystemNavigator.pop();
          }
        },

        child: Scaffold(
          extendBody: true, // Allow body to extend behind the navbar
          body: widget.navigationShell,
          bottomNavigationBar: _CustomBottomNavBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: (index) => _onTap(context, index),
            isGuest: isGuest,
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surface.withOpacity(0.9),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r24),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(
                AppPadding.p24,
                AppPadding.p32,
                AppPadding.p24,
                AppPadding.p16,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: AppSize.s32,
                    ),
                  ),
                  const SizedBox(height: AppSize.s24),
                  Text(
                    AppStrings.exitApp,
                    style: TextStyle(
                      fontSize: AppSize.s20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSize.s12),
                  Text(
                    AppStrings.exitAppMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: AppSize.s32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                          child: Text(
                            AppStrings.cancel,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSize.s12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                          child: const Text(
                            AppStrings.exit,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false;
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
