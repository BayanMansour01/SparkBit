import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparkbit/core/constants/app_colors.dart';
import 'package:sparkbit/core/constants/app_strings.dart';
import 'package:sparkbit/core/widgets/app_loading_indicator.dart';
import 'package:sparkbit/core/widgets/app_button.dart';
import 'package:sparkbit/core/widgets/app_network_image.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';
import 'package:sparkbit/core/widgets/shimmers/app_shimmer.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/main_screen_wrapper.dart';
import '../../data/models/order_model.dart';
import '../providers/orders_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../courses/presentation/providers/courses_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _paginationScheduled = false;

  @override
  void initState() {
    super.initState();
    // Refresh list on every entry as requested
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(ordersProvider);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshList() async {
    _paginationScheduled = false;
    await ref.read(ordersProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.home);
        }
      },
      child: MainScreenWrapper(
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
        onRefresh: () async {
          _paginationScheduled = false;
          await _refreshList();
        },
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

            return Stack(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  itemCount:
                      data.data.length +
                      (ref.read(ordersProvider.notifier).isLoadingMore ? 1 : 0),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    if (index == data.data.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: AppLoadingIndicator(size: 24),
                        ),
                      );
                    }

                    // Pagination check - prevent duplicate calls
                    final notifier = ref.read(ordersProvider.notifier);
                    if (index == data.data.length - 1 &&
                        notifier.hasMore &&
                        !notifier.isLoadingMore &&
                        !_paginationScheduled) {
                      _paginationScheduled = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && !notifier.isLoadingMore) {
                          notifier.loadNextPage().then((_) {
                            // Reset flag after loading (allow next pagination)
                            if (mounted) {
                              setState(() {
                                _paginationScheduled = false;
                              });
                            }
                          });
                        }
                      });
                    }

                    final order = data.data[index];
                    return _OrderCard(
                      order: order,
                      isDark: isDark,
                      onReturn: _refreshList,
                    );
                  },
                ),
                if (ordersState.isLoading)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: theme.colorScheme.surface,
                        child: const _OrdersListSkeleton(itemCount: 5),
                      ),
                    ),
                  ),
              ],
            );
          },
          error: (error, stackTrace) => ErrorView(
            error: error.toString(),
            onRetry: () {
              _paginationScheduled = false;
              ref.read(ordersProvider.notifier).refresh();
            },
          ),
          loading: () => const _OrdersListSkeleton(itemCount: 5),
        ), // when
      ), // wrapper
    ); // scope
  }
}

class _OrdersListSkeleton extends StatelessWidget {
  final int itemCount;

  const _OrdersListSkeleton({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    final palette = AppShimmer.palette(context);

    final items = List<Widget>.generate(itemCount, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 20),
        child: Container(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.border),
          ),
          child: AppShimmer(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _box(palette, width: 150, height: 18, radius: 8),
                      const Spacer(),
                      _box(palette, width: 92, height: 28, radius: 14),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        _thumb(palette),
                        const SizedBox(width: 12),
                        _thumb(palette),
                        const SizedBox(width: 12),
                        _thumb(palette),
                        const SizedBox(width: 12),
                        _thumb(palette),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(palette, width: 54, height: 12, radius: 6),
                          const SizedBox(height: 6),
                          _box(palette, width: 92, height: 15, radius: 7),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _box(palette, width: 38, height: 12, radius: 6),
                          const SizedBox(height: 6),
                          _box(palette, width: 88, height: 18, radius: 8),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _box(palette, width: double.infinity, height: 44, radius: 14),
                ],
              ),
            ),
          ),
        ),
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedHeight) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            children: items,
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: items),
        );
      },
    );
  }

  static Widget _thumb(AppShimmerPalette palette) {
    return _box(palette, width: 60, height: 60, radius: 12);
  }

  static Widget _box(
    AppShimmerPalette palette, {
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: palette.placeholder,
        borderRadius: BorderRadius.circular(radius),
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

        // Reset cart fully + refresh course purchase states
        ref.read(cartProvider.notifier).resetCart();
        ref.invalidate(coursesProvider);
        ref.invalidate(myCoursesProvider);
        ref.invalidate(homePopularCoursesProvider);
        ref.invalidate(homeCategoriesProvider);

        // Refresh the orders list
        onReturn();

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
                            child: AppNetworkImage(
                              imageUrl: item.course.image,
                              fit: BoxFit.cover,
                              errorWidget: Icon(
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
                if (order.status.value == 'awaiting_payment_proof') ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withOpacity(0.12),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Please upload payment proof to confirm your enrollment',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFFCD34D)
                                  : const Color(0xFFB45309),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _cancelOrder(context, ref),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Text(
                          'Cancel Order',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Spacer(),
                      AppButton(
                        text: 'Upload Proof',
                        onPressed: () async {
                          await context.pushNamed(
                            AppRoutes.orderDetailsName,
                            pathParameters: {'id': order.id.toString()},
                          );
                          onReturn();
                        },
                        variant: AppButtonVariant.primary,
                        width: 160,
                        height: 48,
                        icon: Icons.upload_file_rounded,
                        fontSize: 14,
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
