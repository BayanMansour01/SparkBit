import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yuna/core/constants/app_colors.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/error_view.dart';
import 'package:yuna/core/widgets/app_button.dart';
import 'package:yuna/core/utils/snackbar_utils.dart';
import '../../data/models/order_model.dart';
import '../providers/order_detail_provider.dart';
import '../providers/orders_provider.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickAndUploadProof() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _isUploading = true);

      // Perform upload
      await ref
          .read(ordersProvider.notifier)
          .uploadPaymentProof(widget.orderId, image.path);

      // Refresh details
      ref.invalidate(orderDetailProvider(widget.orderId));

      if (mounted) {
        AppSnackBar.showSuccess(context, 'Payment proof uploaded successfully');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Upload failed: $e');
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
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
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderDetailProvider(widget.orderId));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Enrollment Details',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: theme.iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: orderAsync.when(
        data: (order) => _buildContent(context, order, isDark),
        error: (error, stack) => ErrorView(
          error: error.toString(),
          onRetry: () => ref.refresh(orderDetailProvider(widget.orderId)),
        ),
        loading: () => const Center(child: AppLoadingIndicator()),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OrderModel order, bool isDark) {
    final statusColor = _getStatusColor(order.status.value);
    final cardColor = isDark ? AppColors.darkCard : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor =
        isDark ? Colors.grey[400]! : const Color(0xFF64748B);

    return SingleChildScrollView(
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
                        color: statusColor.withOpacity(0.2), width: 1),
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
                  '\$${order.totalPrice}',
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
                    height: 1),
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
                    const Center(child: CircularProgressIndicator())
                  else
                    AppButton(
                      text: 'Upload Payment Proof',
                      onPressed: _pickAndUploadProof,
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
            Text(
              'Payment Proof',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
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
                child: Image.network(
                  order.paymentProof!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
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
                            style: GoogleFonts.outfit(color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
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
              return Container(
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
                      child: Image.network(
                        item.course.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
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
                      '\$${item.price}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
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
                        : const Color(0xFFFECACA)),
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
