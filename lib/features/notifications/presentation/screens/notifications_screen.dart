import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/main_screen_wrapper.dart';
import '../../../../core/widgets/shimmers/app_page_skeleton.dart';
import '../providers/notifications_provider.dart';
import '../../data/models/notification_model.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/notification_navigator.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: unused_result
      ref.refresh(notificationsProvider(1));
    });
  }

  void _handleNotificationTap(NotificationModel notification) {
    NotificationNavigator.navigate(
      notificationType: notification.notificationType,
      data: notification.data,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider(1));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MainScreenWrapper(
      appBar: _buildAppBar(context),
      onRefresh: () async {
        ref.invalidate(notificationsProvider(1));
        await ref.read(notificationsProvider(1).future);
      },
      child: notificationsAsync.when(
        data: (paginatedData) {
          final notifications = paginatedData.data;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Notifications Yet',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We\'ll notify you when something\nimportant happens.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationCard(
                notification: notification,
                isDark: isDark,
                onTap: () => _handleNotificationTap(notification),
              );
            },
          );
        },
        loading: () => const AppPageSkeleton(itemCount: 6, cardHeight: 110),
        error: (error, stack) => ErrorView(
          error: error,
          onRetry: () => ref.refresh(notificationsProvider(1)),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLg,
        vertical: AppSizes.space10,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: 20,
            onPressed: () => context.pop(),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: AppSizes.space8),
          Text(
            'Notifications',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = notification.readAt == null;
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    // Determine icon based on type
    IconData iconData = Icons.notifications_rounded;
    Color iconColor = AppColors.primary;

    switch (notification.notificationType) {
      case 'order_status_changed':
        iconData = Icons.shopping_bag_rounded;
        iconColor = Colors.orange;
        break;

      case 'course_update':
        iconData = Icons.school_rounded;
        iconColor = Colors.blue;
        break;

      case 'new_lesson':
        iconData = Icons.play_circle_filled_rounded;
        iconColor = Colors.green;
        break;

      case 'general':
        iconData = Icons.info_rounded;
        iconColor = AppColors.primary;
        break;

      default:
        iconData = Icons.notifications_rounded;
        iconColor = AppColors.primary;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: isUnread ? iconColor.withOpacity(0.05) : cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnread
              ? iconColor.withOpacity(0.2)
              : theme.dividerColor.withOpacity(isDark ? 0.1 : 0.05),
          width: isUnread ? 1.5 : 1,
        ),
        boxShadow: [
          if (!isUnread)
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: iconColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDate(notification.createdAt),
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM dd, yyyy').format(date);
      }
    } catch (e) {
      return dateStr.split(' ').first;
    }
  }
}
