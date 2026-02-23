import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkbit/core/utils/snackbar_utils.dart';
import '../../../../core/constants/app_routes.dart';
import 'package:sparkbit/core/widgets/app_button.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';

class AddToCartButton extends ConsumerWidget {
  final CourseModel course;
  final bool showFullButton;

  const AddToCartButton({
    super.key,
    required this.course,
    this.showFullButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInCart = ref.watch(isInCartProvider(course.id));
    final theme = Theme.of(context);

    // Don't show button for purchased courses
    if (course.isPurchased) {
      return const SizedBox.shrink();
    }

    // Don't show button for free courses
    if (course.isFree) {
      return const SizedBox.shrink();
    }

    if (!showFullButton) {
      // Icon button version
      return IconButton(
        onPressed: isInCart
            ? () => _goToCart(context)
            : () => _handleAddToCart(context, ref),
        icon: Icon(
          isInCart ? Icons.shopping_cart : Icons.add_shopping_cart_outlined,
          color: isInCart ? theme.colorScheme.primary : null,
        ),
        tooltip: isInCart ? 'View Cart' : 'Add to Cart',
      );
    }

    // Full button version
    return AppButton(
      text: isInCart ? 'View Cart' : 'Add to Cart',
      onPressed: isInCart
          ? () => _goToCart(context)
          : () => _handleAddToCart(context, ref),
      icon: isInCart ? Icons.shopping_cart : Icons.add_shopping_cart_outlined,
      variant: isInCart ? AppButtonVariant.secondary : AppButtonVariant.primary,
      height: 48,
    );
  }

  /// Handle add to cart - check if user is logged in first
  void _handleAddToCart(BuildContext context, WidgetRef ref) {
    // Check if user is logged in
    final userProfile = ref.read(userProfileProvider).valueOrNull;
    final isGuest = userProfile == null || userProfile.id == -1;

    if (isGuest) {
      // Show dialog to ask user to sign in
      _showSignInDialog(context);
    } else {
      // User is logged in, add to cart
      _addToCart(context, ref);
    }
  }

  /// Show sign in required dialog
  void _showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.login_rounded,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: const Text(
          'Sign In Required',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Please sign in to add courses to your cart and make purchases.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Sign In',
            width: 120,
            height: 44,
            onPressed: () {
              Navigator.pop(context);
              context.push(AppRoutes.signIn);
            },
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref) {
    ref.read(cartProvider.notifier).addToCart(course);

    // Show success snackbar
    AppSnackBar.showSuccess(context, 'Course added to cart');
  }

  void _goToCart(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
  }
}
