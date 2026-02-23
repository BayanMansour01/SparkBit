import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkbit/core/constants/app_routes.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';

class CartBadgeIcon extends ConsumerWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemCountProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ), // مسافة بسيطة حول الأيقونة
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.cartName),
            iconSize: 30, // الحجم الذي طلبته
            padding: EdgeInsets.zero, // لإزالة الفراغات الداخلية الزائدة
            constraints:
                const BoxConstraints(), // للسماح للأيقونة بأخذ حجمها الحقيقي
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (itemCount > 0)
            Positioned(
              top: 0, // رفع العداد للأعلى قليلاً
              right: 0, // وضعه في الزاوية اليمنى
              child: IgnorePointer(
                // لضمان أن الضغط يمر دائماً لزر السلة
                child: Container(
                  padding: const EdgeInsets.all(2),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle, // الدائرة دائماً أوضح للعدادات
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1, // لضمان توسط الرقم داخل الدائرة تماماً
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
