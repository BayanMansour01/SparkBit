import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuna/core/utils/snackbar_utils.dart';
import 'package:yuna/core/widgets/app_button.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary_card.dart';
import '../widgets/empty_cart_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final theme = Theme.of(context);

    // Listen to errors
    ref.listen<CartState>(cartProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        AppSnackBar.showError(context, next.error!);
        // Clear error after showing
        Future.microtask(() => ref.read(cartProvider.notifier).clearError());
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface, // Use surface for clean look
      appBar: AppBar(
        title: Text(
          'Selected Courses',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: false, // Left aligned title looks more modern usually
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (cartState.items.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  _showClearCartDialog(context, ref);
                },
                icon: Icon(
                  Icons.delete_sweep_rounded,
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                tooltip: 'Clear List',
              ),
            ),
        ],
      ),
      body: cartState.items.isEmpty
          ? const EmptyCartWidget()
          : Column(
              children: [
                // Cart Items List
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    itemCount: cartState.items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartState.items[index];
                      return CartItemCard(
                        cartItem: item,
                        onRemove: () {
                          ref
                              .read(cartProvider.notifier)
                              .removeFromCart(item.course.id);
                        },
                      );
                    },
                  ),
                ),

                // Cart Summary
                CartSummaryCard(
                  totalPrice: cartState.totalPrice,
                  itemCount: cartState.itemCount,
                  isLoading: cartState.isLoading,
                  onCheckout: () => context.pushNamed(AppRoutes.checkoutName),
                ),
              ],
            ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear List'),
        content: const Text(
          'Are you sure you want to remove all selected courses?',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Clear',
            width: 100,
            height: 44,
            variant: AppButtonVariant.error,
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
