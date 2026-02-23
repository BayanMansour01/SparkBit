import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparkbit/core/constants/app_colors.dart';
import 'package:sparkbit/core/constants/app_strings.dart';
import 'package:sparkbit/core/widgets/app_loading_indicator.dart';
import 'package:sparkbit/core/widgets/app_button.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/main_screen_wrapper.dart';
import '../../data/models/order_model.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Pagination is handled by the scroll controller in the ListView,
    // but since we are using MainScreenWrapper's scroll, we might need a different approach
    // if we want to keep the ListView performance.
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshList() async {
    ref.invalidate(ordersProvider);
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return MainScreenWrapper(
      appBar: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.home);
                    }
                  },
                ),
                Text(
                  'My Enrollments',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      onRefresh: _refreshList,
      child: ordersState.when(
        data: (data) {
          if (data.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      size: 64,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No orders found',
                    style: GoogleFonts.outfit(
                      color: theme.colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You haven\'t placed any orders yet.',
                    style: GoogleFonts.outfit(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            itemCount:
                data.data.length +
                (ref.read(ordersProvider.notifier).isLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              if (index == data.data.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: AppLoadingIndicator(size: 24),
                  ),
                );
              }

              // Pagination check
              if (index == data.data.length - 1 &&
                  ref.read(ordersProvider.notifier).hasMore &&
                  !ref.read(ordersProvider.notifier).isLoadingMore) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(ordersProvider.notifier).loadNextPage();
                });
              }

              final order = data.data[index];
              return _OrderCard(
                order: order,
                isDark: isDark,
                onReturn: _refreshList,
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorView(
          error: error.toString(),
          onRetry: () => ref.read(ordersProvider.notifier).refresh(),
        ),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: AppLoadingIndicator(),
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final OrderModel order;
  final bool isDark;
  final VoidCallback onReturn;

  const _OrderCard({
    required this.order,
    required this.isDark,
    required this.onReturn,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF22C55E); // Green
      case 'rejected':
        return const Color(0xFFEF4444); // Red
      case 'awaiting_payment_proof':
        return const Color(0xFFF59E0B); // Orange
      case 'pending':
        return const Color(0xFF3B82F6); // Blue
      case 'cancelled':
        return const Color(0xFF9CA3AF); // Gray
      default:
        return Colors.grey;
    }
  }

  Future<void> _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Order',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel this order?',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No', style: GoogleFonts.outfit()),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Yes, Cancel',
            width: 130,
            height: 44,
            variant: AppButtonVariant.error,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(ordersProvider.notifier).cancelOrder(order.id);
        if (context.mounted) {
          AppSnackBar.showSuccess(context, 'Enrollment cancelled successfully');
        }
      } catch (e) {
        if (context.mounted) {
          AppSnackBar.showError(context, 'Failed to cancel enrollment: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(order.status.value);
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark
        ? Colors.grey[400]
        : const Color(0xFF64748B);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            await context.pushNamed(
              AppRoutes.orderDetailsName,
              pathParameters: {'id': order.id.toString()},
            );
            onReturn();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enrollment #${order.id}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: statusColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        order.status.displayLabel,
                        style: GoogleFonts.outfit(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Thumbnails
                if (order.items.isNotEmpty) ...[
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: order.items.length > 4
                          ? 4
                          : order.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        if (index == 3 && order.items.length > 4) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                            ),
                            child: Center(
                              child: Text(
                                '+${order.items.length - 3}',
                                style: GoogleFonts.outfit(
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }
                        final item = order.items[index];
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[200]!,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              11,
                            ), // slightly less than container
                            child: Image.network(
                              item.course.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_not_supported_rounded,
                                size: 20,
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Footer Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Courses',
                          style: GoogleFonts.outfit(
                            color: secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.items.length} Course(s)',
                          style: GoogleFonts.outfit(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.outfit(
                            color: secondaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.formatPrice(order.totalPrice),
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Actions
                if (order.status.value == 'pending') ...[
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    height: 1,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Cancel Enrollment',
                    onPressed: () => _cancelOrder(context, ref),
                    variant: AppButtonVariant.error,
                    height: 48,
                    icon: Icons.close_rounded,
                  ),
                ] else if (order.status.value == 'awaiting_payment_proof') ...[
                  const SizedBox(height: 16),
                  Divider(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    height: 1,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.upload_file_rounded,
                          size: 16,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Upload Payment Proof',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: secondaryTextColor,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
