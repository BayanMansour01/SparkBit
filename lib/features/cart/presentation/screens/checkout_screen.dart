import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import 'package:sparkbit/core/widgets/app_button.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';
import '../providers/cart_provider.dart';
import '../widgets/order_summary_widget.dart';
import '../../data/models/cart_item_model.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  static const routeName = '/checkout';

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  List<CartItemModel> _lastItems =
      []; // To persist items in UI during success transition
  double _lastPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final theme = Theme.of(context);

    if (cartState.items.isNotEmpty) {
      _lastItems = cartState.items;
      _lastPrice = cartState.totalPrice;
    }

    // Listen to order success and errors
    ref.listen<CartState>(cartProvider, (previous, next) {
      if (next.lastOrder != null && previous?.lastOrder != next.lastOrder) {
        _showOrderSuccessDialog(context, next.lastOrder!.id);
      }
      if (next.error != null && next.error != previous?.error) {
        AppSnackBar.showError(context, next.error!);
        // Clear error after showing
        Future.microtask(() => ref.read(cartProvider.notifier).clearError());
      }
    });

    return PopScope(
      canPop: cartState.lastOrder == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (cartState.lastOrder != null) {
          // If order was successful, back button goes to Home
          ref.read(cartProvider.notifier).clearLastOrder();
          context.goNamed(AppRoutes.homeName);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Enrollment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: cartState.items.isEmpty && cartState.lastOrder == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cart is Empty',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.disabledColor,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Order Summary
                    OrderSummaryWidget(
                      items: _lastItems,
                      totalPrice: _lastPrice,
                    ),

                    const SizedBox(height: 32),

                    AppButton(
                      text: cartState.lastOrder != null
                          ? 'Order Confirmed'
                          : 'Confirm Enrollment - ${AppStrings.formatPrice(cartState.totalPrice)}',
                      isLoading: cartState.isLoading,
                      onPressed: cartState.lastOrder != null
                          ? () {} // Disable button after success
                          : () {
                              ref.read(cartProvider.notifier).createOrder();
                            },
                      icon: cartState.lastOrder != null
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _showOrderSuccessDialog(BuildContext context, int orderId) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF22C55E),
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Enrollment Successful!',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Thank you for your purchase.\nPlease upload your payment proof to complete the process.',
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'View Enrollment Details',
              onPressed: () {
                ref.read(cartProvider.notifier).clearLastOrder();
                context.pushNamed(
                  AppRoutes.orderDetailsName,
                  pathParameters: {'id': orderId.toString()},
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clearLastOrder();
                context.goNamed(AppRoutes.homeName);
              },
              child: Text(
                'Browse More Courses',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
