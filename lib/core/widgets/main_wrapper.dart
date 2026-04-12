import 'dart:async';
import 'dart:io' show InternetAddress, SocketException;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../resources/values_manager.dart';
import '../utils/dialog_utils.dart';
import 'app_update_listener.dart';
import '../../features/app_config/presentation/providers/app_config_provider.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../features/orders/presentation/providers/orders_provider.dart';
import '../../features/courses/presentation/providers/courses_provider.dart';
import '../../features/home/presentation/providers/home_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/snackbar_utils.dart';

class MainWrapper extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  /// Static callback for the BackButtonDispatcher to call when on root tabs.
  /// Set by _MainWrapperState in initState, cleared in dispose.
  static Future<bool> Function()? handleBackPress;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  ConsumerState<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends ConsumerState<MainWrapper>
    with WidgetsBindingObserver {
  /// Tab navigation history stack.
  /// Each tab switch pushes the previous index.
  /// Back button pops from this stack to return to the previous tab.
  /// When empty → show exit dialog.
  final List<int> _tabHistory = [];

  /// Flag to prevent didUpdateWidget from adding to history during back navigation
  bool _isGoingBack = false;

  /// Track when app goes to background and throttle resume refreshes.
  DateTime? _lastBackgroundAt;
  DateTime? _lastResumeRefreshAt;
  Timer? _networkRecoveryTimer;
  Timer? _connectionBannerTimer;
  bool _isRecoveryInProgress = false;
  bool _awaitingNetworkRecovery = false;
  bool _showConnectionBanner = false;
  bool _isConnectionOffline = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupNotificationListeners();
    // Register the back press handler for the BackButtonDispatcher
    MainWrapper.handleBackPress = _onBackPressed;
    unawaited(_checkInitialConnectivity());
  }

  @override
  void dispose() {
    MainWrapper.handleBackPress = null;
    _networkRecoveryTimer?.cancel();
    _connectionBannerTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkInitialConnectivity() async {
    final hasInternet = await _hasInternetConnection();
    if (!mounted || hasInternet) return;

    _showOfflineBanner();
    _startNetworkRecoveryRetries();
  }

  /// Detect tab changes from ANY source (nav bar, context.go(), etc.)
  @override
  void didUpdateWidget(covariant MainWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = widget.navigationShell.currentIndex;
    final oldIndex = oldWidget.navigationShell.currentIndex;

    // Tab changed — push old index to history
    if (newIndex != oldIndex) {
      if (_isGoingBack) {
        // Back navigation — don't add to history (already handled by _onBackPressed)
        _isGoingBack = false;
        debugPrint(
          '📱 Tab back: $oldIndex → $newIndex | History: $_tabHistory',
        );
      } else {
        // Forward navigation — track in history
        if (_tabHistory.isEmpty || _tabHistory.last != oldIndex) {
          _tabHistory.add(oldIndex);
        }

        // Cap stack size to prevent unbounded growth
        if (_tabHistory.length > 10) {
          _tabHistory.removeAt(0);
        }

        debugPrint(
          '📱 Tab changed: $oldIndex → $newIndex | History: $_tabHistory',
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _lastBackgroundAt = DateTime.now();
      return;
    }

    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      final secondsAway = _lastBackgroundAt == null
          ? 999
          : now.difference(_lastBackgroundAt!).inSeconds;
      final secondsSinceLastRefresh = _lastResumeRefreshAt == null
          ? 999
          : now.difference(_lastResumeRefreshAt!).inSeconds;

      // Ignore very short transitions (e.g. picker/app switch <2s),
      // and throttle frequent refreshes.
      if (secondsAway < 2 && secondsSinceLastRefresh < 15) {
        return;
      }
      if (secondsSinceLastRefresh < 6) {
        return;
      }

      unawaited(_tryRecoverAfterResume());
    }
  }

  Future<void> _tryRecoverAfterResume() async {
    if (_isRecoveryInProgress) return;

    _isRecoveryInProgress = true;
    try {
      final hasInternet = await _hasInternetConnection();

      if (hasInternet) {
        final wasRecovering = _awaitingNetworkRecovery || _isConnectionOffline;
        _networkRecoveryTimer?.cancel();
        _awaitingNetworkRecovery = false;
        if (wasRecovering) {
          _showOnlineBanner();
        }
        await _refreshCoreData();
      } else {
        _showOfflineBanner();
        _startNetworkRecoveryRetries();
      }
    } finally {
      _isRecoveryInProgress = false;
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'one.one.one.one',
      ).timeout(const Duration(seconds: 2));

      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }

  void _startNetworkRecoveryRetries() {
    if (_awaitingNetworkRecovery) return;

    _awaitingNetworkRecovery = true;
    _showOfflineBanner();
    _networkRecoveryTimer?.cancel();

    var attempts = 0;
    _networkRecoveryTimer = Timer.periodic(const Duration(seconds: 4), (
      timer,
    ) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_isRecoveryInProgress) return;

      attempts++;
      _isRecoveryInProgress = true;
      try {
        final hasInternet = await _hasInternetConnection();
        if (hasInternet) {
          timer.cancel();
          _awaitingNetworkRecovery = false;
          await _refreshCoreData();
          _showOnlineBanner();
          return;
        }

        if (attempts >= 6) {
          timer.cancel();
          _awaitingNetworkRecovery = false;
        }
      } finally {
        _isRecoveryInProgress = false;
      }
    });
  }

  Future<void> _refreshCoreData() async {
    _lastResumeRefreshAt = DateTime.now();

    ref.invalidate(appConfigProvider);
    ref.invalidate(homeDataProvider);
    ref.invalidate(homePopularCoursesProvider);
    ref.invalidate(homeCategoriesProvider);
    ref.invalidate(unreadNotificationsCountProvider);

    // Trigger immediate fetches so the user sees fresh data quickly.
    unawaited(_ignorePrefetchErrors(ref.read(appConfigProvider.future)));
    unawaited(_ignorePrefetchErrors(ref.read(homeDataProvider.future)));
    unawaited(
      _ignorePrefetchErrors(ref.read(homePopularCoursesProvider.future)),
    );
    unawaited(_ignorePrefetchErrors(ref.read(homeCategoriesProvider.future)));
    unawaited(
      _ignorePrefetchErrors(ref.read(unreadNotificationsCountProvider.future)),
    );

    unawaited(ref.read(myCoursesProvider.notifier).refreshData());
    unawaited(ref.read(coursesProvider.notifier).refreshData());
  }

  Future<void> _ignorePrefetchErrors<T>(Future<T> future) async {
    try {
      await future;
    } catch (_) {
      // Intentionally ignored: this is a best-effort warm-up request.
    }
  }

  void _showOfflineBanner() {
    if (!mounted) return;
    if (_showConnectionBanner && _isConnectionOffline) return;

    _connectionBannerTimer?.cancel();
    setState(() {
      _showConnectionBanner = true;
      _isConnectionOffline = true;
    });
  }

  void _showOnlineBanner() {
    if (!mounted) return;

    _connectionBannerTimer?.cancel();
    setState(() {
      _showConnectionBanner = true;
      _isConnectionOffline = false;
    });

    _connectionBannerTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showConnectionBanner = false;
      });
    });
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
    final currentIndex = widget.navigationShell.currentIndex;

    // If tapping the same tab, reset it to initial location
    if (index == currentIndex) {
      widget.navigationShell.goBranch(index, initialLocation: true);
      return;
    }

    // History tracking is handled by didUpdateWidget automatically
    widget.navigationShell.goBranch(index, initialLocation: false);
  }

  /// Handle back button press (called from BackButtonDispatcher):
  /// - If history has entries → go back to previous tab
  /// - If stack is empty → show exit dialog
  /// Returns true = event consumed, false = not handled.
  Future<bool> _onBackPressed() async {
    debugPrint('🔙 _onBackPressed | History: $_tabHistory');

    if (_tabHistory.isNotEmpty) {
      // Pop the last tab from history and navigate to it
      final previousIndex = _tabHistory.removeLast();
      debugPrint(
        '🔙 Going back to tab $previousIndex | Remaining: $_tabHistory',
      );
      _isGoingBack = true; // Prevent didUpdateWidget from re-adding to history
      widget.navigationShell.goBranch(previousIndex, initialLocation: false);
      return true;
    } else {
      // Stack is empty → show exit dialog
      debugPrint('🔙 Stack empty → showing exit dialog');
      if (!mounted) return false;
      final shouldExit = await DialogUtils.showExitDialog(context);
      if (shouldExit && mounted) {
        SystemNavigator.pop();
      }
      return true; // Consumed (dialog was shown)
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final isGuest = profile?.id == -1;

    return AppUpdateListener(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            extendBody: true,
            body: widget.navigationShell,
            bottomNavigationBar: _CustomBottomNavBar(
              currentIndex: widget.navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
              isGuest: isGuest,
            ),
          ),
          IgnorePointer(
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppPadding.p16,
                    AppPadding.p8,
                    AppPadding.p16,
                    0,
                  ),
                  child: AnimatedSlide(
                    offset: _showConnectionBanner
                        ? Offset.zero
                        : const Offset(0, -1),
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      opacity: _showConnectionBanner ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p14,
                          vertical: AppPadding.p10,
                        ),
                        decoration: BoxDecoration(
                          color: _isConnectionOffline
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF16A34A),
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isConnectionOffline
                                  ? Icons.wifi_off_rounded
                                  : Icons.wifi_rounded,
                              color: Colors.white,
                              size: AppSize.s20,
                            ),
                            const SizedBox(width: AppSize.s8),
                            Expanded(
                              child: Text(
                                _isConnectionOffline
                                    ? 'No internet connection'
                                    : 'Back online',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
              color: Colors.black.withValues(alpha: 0.3),
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
                ).colorScheme.surfaceContainer.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(AppRadius.r40),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
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
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
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
