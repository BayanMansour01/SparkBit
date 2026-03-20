import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sparkbit/core/constants/app_colors.dart';
import 'package:sparkbit/core/constants/app_strings.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/error_view.dart';
import 'package:sparkbit/core/widgets/app_button.dart';
import 'package:sparkbit/core/widgets/app_network_image.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';
import 'package:sparkbit/core/widgets/shimmers/app_shimmer.dart';
import '../../../../core/widgets/main_screen_wrapper.dart';
import '../../data/models/order_model.dart';
import '../providers/order_detail_provider.dart';
import '../providers/orders_provider.dart';
import '../../../courses/presentation/providers/courses_provider.dart';
import 'package:sparkbit/features/home/presentation/providers/home_provider.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  bool _isUploading = false;
  bool _shouldRefreshListOnPop = false;

  static const String _proofActionConfirm = 'confirm';
  static const String _proofActionChooseAnother = 'choose_another';

  @override
  void initState() {
    super.initState();
    // Refresh details on every entry as requested
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(orderDetailProvider(widget.orderId));
    });
  }

  Future<void> _pickAndUploadProof(BuildContext context, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;

    // Keep looping until user confirms an image or explicitly cancels.
    while (mounted) {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      if (!mounted) return;
      final action = await _showConfirmationDialog(context, picked);
      if (action == _proofActionConfirm) {
        image = picked;
        break;
      }
      if (action == _proofActionChooseAnother) {
        continue;
      }
      return;
    }

    if (image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Perform upload
      await ref
          .read(ordersProvider.notifier)
          .uploadPaymentProof(widget.orderId, image.path);

      // Refresh only the specific order detail
      ref.invalidate(orderDetailProvider(widget.orderId));

      // Mark as needing refresh on pop
      _shouldRefreshListOnPop = true;

      if (mounted) {
        AppSnackBar.showSuccess(context, 'Payment proof uploaded successfully');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Upload failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _cancelOrder(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Cancel Enrollment',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel this enrollment?',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('No', style: GoogleFonts.outfit()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('Yes, Cancel', style: GoogleFonts.outfit()),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(ordersProvider.notifier).cancelOrder(widget.orderId);

      // Invalidate providers to reflect cancellation
      ref.invalidate(ordersProvider); // Make sure list is refreshed
      ref.invalidate(
        orderDetailProvider(widget.orderId),
      ); // Refresh current screen
      _shouldRefreshListOnPop = true;

      if (mounted) {
        AppSnackBar.showSuccess(context, 'Enrollment cancelled successfully');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Cancellation failed: $e');
      }
    }
  }

  Future<String> _showConfirmationDialog(
    BuildContext context,
    XFile image,
  ) async {
    final file = File(image.path);
    final fileSize = await file.length();
    final fileSizeInMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return await showDialog<String>(
          context: context,
          builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Confirm Payment Proof',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image Preview
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        file,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // File Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'File Information',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'File Name:',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(
                                image.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'File Size:',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                              Text(
                                '$fileSizeInMB MB',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                Navigator.pop(ctx, _proofActionChooseAnother),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: theme.colorScheme.outline.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),
                            child: Text(
                              'Choose Another',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Confirm button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pop(ctx, _proofActionConfirm),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: theme.colorScheme.primary,
                            ),
                            child: Text(
                              'Confirm Upload',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ) ??
        '';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF22C55E); // Success Green
      case 'rejected':
        return const Color(0xFFEF4444); // Error Red
      case 'awaiting_payment_proof':
        return const Color(0xFFF59E0B); // Amber/Orange
      case 'pending':
        return const Color(0xFF3B82F6); // Blue
      case 'cancelled':
        return const Color(0xFF9CA3AF); // Gray
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderDetailProvider(widget.orderId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Check if we need to refresh based on actions
        if (_shouldRefreshListOnPop) {
          debugPrint(
            '🔄 Order details changed, refreshing orders list on pop...',
          );
          ref.invalidate(ordersProvider);
        } else if (orderAsync.hasValue) {
          final order = orderAsync.value;
          // Also check if status changed externally (e.g. from notification) to approved
          if (order?.status.value == 'approved') {
            ref.invalidate(myCoursesProvider);
            ref.invalidate(ordersProvider);
          }
        }

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
                    'Enrollment Details',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: theme.appBarTheme.foregroundColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        onRefresh: () async {
          // Simple single-shot refresh
          ref.invalidate(orderDetailProvider(widget.orderId));
        },
        child: orderAsync.when(
          data: (order) {
            if (orderAsync.isLoading) {
              return ColoredBox(
                color: theme.colorScheme.surface,
                child: const _OrderDetailSkeleton(),
              );
            }
            return _buildContent(context, ref, order, isDark);
          },
          error: (error, stack) => ErrorView(
            error: error.toString(),
            onRetry: () => ref.refresh(orderDetailProvider(widget.orderId)),
          ),
          loading: () => const _OrderDetailSkeleton(),
        ), // when
      ), // wrapper
    ); // scope
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    OrderModel order,
    bool isDark,
  ) {
    final statusColor = _getStatusColor(order.status.value);
    final canEditPaymentProof = order.status.value.toLowerCase() == 'pending';
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Order Header Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
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
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.formatPrice(order.totalPrice),
                  style: GoogleFonts.outfit(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Amount',
                  style: GoogleFonts.outfit(
                    color: secondaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Divider(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  height: 1,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(
                      'Enrollment ID',
                      '#${order.id}',
                      textColor,
                      secondaryTextColor,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                    ),
                    _buildInfoItem(
                      'Date',
                      _formatDate(order.id),
                      textColor,
                      secondaryTextColor,
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                    ),
                    _buildInfoItem(
                      'Courses',
                      '${order.items.length}',
                      textColor,
                      secondaryTextColor,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Upload Proof Action
          if (order.status.value == 'awaiting_payment_proof') ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF3F2C0B)
                    : const Color(0xFFFFF7ED), // Dark amber for dark mode
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF78350F)
                      : const Color(0xFFFED7AA),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.upload_file_rounded,
                          color: Color(0xFFF59E0B),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Proof Required',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? const Color(0xFFFCD34D)
                                    : const Color(0xFF9A3412),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please upload a clear image of your payment proof or transfer receipt to verify your enrollment.',
                              style: GoogleFonts.outfit(
                                color: isDark
                                    ? const Color(0xFFFCD34D).withOpacity(0.8)
                                    : const Color(0xFF9A3412).withOpacity(0.8),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_isUploading)
                    const Center(child: AppLoadingIndicator(size: 26))
                  else
                    AppButton(
                      text: 'Upload Payment Proof',
                      onPressed: () => _pickAndUploadProof(context, ref),
                      icon: Icons.cloud_upload_outlined,
                      height: 54,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Payment Proof Display
          if (order.paymentProof != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Proof',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
                if (canEditPaymentProof)
                  TextButton.icon(
                    onPressed: () => _pickAndUploadProof(context, ref),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: Text(
                      'Edit',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        // Show full image in a dialog
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: InteractiveViewer(
                              child: AppNetworkImage(
                                imageUrl: order.paymentProof!,
                                fit: BoxFit.contain,
                                errorWidget: Container(
                                  color: isDark
                                      ? Colors.grey[800]
                                      : Colors.grey[100],
                                  child: Icon(
                                    Icons.image_not_supported_rounded,
                                    color: secondaryTextColor,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: AppNetworkImage(
                        imageUrl: order.paymentProof!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: Container(
                          height: 220,
                          color: isDark ? Colors.grey[800] : Colors.grey[50],
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.broken_image_rounded,
                                  color: secondaryTextColor,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Image loading failed',
                                  style: GoogleFonts.outfit(
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (canEditPaymentProof)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Order Items
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Included Courses',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = order.items[index];
              // Use the new isolated widget to prevent rebuilds
              return _CourseOrderItem(
                item: item,
                cardColor: cardColor,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDark: isDark,
              );
            },
          ),

          if (order.rejectedReason != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF450A0A)
                    : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF7F1D1D)
                      : const Color(0xFFFECACA),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF7F1D1D)
                              : const Color(0xFFFECACA),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: isDark
                              ? const Color(0xFFEF4444)
                              : const Color(0xFFB91C1C),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Enrollment Rejected',
                        style: GoogleFonts.outfit(
                          color: isDark
                              ? const Color(0xFFEF4444)
                              : const Color(0xFFB91C1C),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    order.rejectedReason!,
                    style: GoogleFonts.outfit(
                      color: isDark
                          ? const Color(0xFFFECACA)
                          : const Color(0xFF7F1D1D),
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: secondaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: textColor,
            fontSize: 18, // Slightly larger
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _formatDate(int seed) {
    final now = DateTime.now();
    // Using a simple formatter for now
    return '${now.day}/${now.month}/${now.year}';
  }
}

class _OrderDetailSkeleton extends StatelessWidget {
  const _OrderDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final palette = AppShimmer.palette(context);

    final children = <Widget>[
      Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.border),
        ),
        child: AppShimmer(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _box(palette, width: 120, height: 32, radius: 16),
                const SizedBox(height: 20),
                _box(palette, width: 170, height: 42, radius: 10),
                const SizedBox(height: 8),
                _box(palette, width: 90, height: 14, radius: 7),
                const SizedBox(height: 24),
                Divider(color: palette.border, height: 1),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _infoColumn(palette),
                    _divider(palette),
                    _infoColumn(palette),
                    _divider(palette),
                    _infoColumn(palette),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
      Container(
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
                    _box(palette, width: 36, height: 36, radius: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(palette, width: 150, height: 16, radius: 8),
                          const SizedBox(height: 6),
                          _box(
                            palette,
                            width: double.infinity,
                            height: 12,
                            radius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _box(palette, width: double.infinity, height: 54, radius: 14),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          _box(palette, width: 4, height: 20, radius: 2),
          const SizedBox(width: 8),
          _box(palette, width: 140, height: 18, radius: 8),
        ],
      ),
      const SizedBox(height: 16),
      ...List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16),
          child: Container(
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.border),
            ),
            child: AppShimmer(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _box(palette, width: 80, height: 80, radius: 14),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(
                            palette,
                            width: double.infinity,
                            height: 16,
                            radius: 8,
                          ),
                          const SizedBox(height: 8),
                          _box(palette, width: 130, height: 13, radius: 7),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _box(palette, width: 70, height: 18, radius: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedHeight) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: children,
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        );
      },
    );
  }

  static Widget _infoColumn(AppShimmerPalette palette) {
    return Column(
      children: [
        _box(palette, width: 56, height: 12, radius: 6),
        const SizedBox(height: 8),
        _box(palette, width: 60, height: 18, radius: 8),
      ],
    );
  }

  static Widget _divider(AppShimmerPalette palette) {
    return Container(width: 1, height: 40, color: palette.border);
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

/// A separate widget for the course item in the order details.
/// This isolates the `ref.read` call and prevents the entire screen from
/// triggering provider re-fetches during rebuilds.
class _CourseOrderItem extends ConsumerWidget {
  final OrderItemModel item;
  final Color cardColor;
  final Color textColor;
  final Color secondaryTextColor;
  final bool isDark;

  const _CourseOrderItem({
    required this.item,
    required this.cardColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        // Try to find the course in loaded lists
        final course = ref.read(courseByIdProvider(item.course.id));

        if (course != null) {
          // Navigate to course details
          context.push(AppRoutes.courseDetails, extra: course);
        } else {
          // Course not in loaded lists, navigate to My Courses
          AppSnackBar.showInfo(context, 'Opening your courses...');
          context.go(AppRoutes.myCourses);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AppNetworkImage(
                imageUrl: item.course.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorWidget: Container(
                  width: 80,
                  height: 80,
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    color: secondaryTextColor,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.course.title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.person_rounded,
                        size: 14,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.course.instructor.name,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppStrings.formatPrice(item.price),
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
