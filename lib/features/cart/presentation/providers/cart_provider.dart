import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/di/service_locator.dart';
import '../../../courses/data/models/course_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../../../features/orders/data/models/order_model.dart';
import '../../../../features/orders/domain/repositories/order_repository.dart';

// Cart State
class CartState {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;
  final OrderModel? lastOrder;

  CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.lastOrder,
  });

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? error,
    OrderModel? lastOrder,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastOrder: lastOrder ?? this.lastOrder,
    );
  }

  // Calculate total price
  double get totalPrice {
    return items.fold(0.0, (sum, item) {
      final price = double.tryParse(item.course.price) ?? 0.0;
      return sum + price;
    });
  }

  // Get total items count
  int get itemCount => items.length;

  // Check if course is in cart
  bool isInCart(int courseId) {
    return items.any((item) => item.course.id == courseId);
  }
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  final OrderRepository _orderRepository;

  CartNotifier(this._orderRepository) : super(CartState());

  // Add course to cart
  void addToCart(CourseModel course) {
    // Check if already in cart
    if (state.isInCart(course.id)) {
      state = state.copyWith(error: 'Course already in cart');
      return;
    }

    // Check if already purchased
    if (course.isPurchased) {
      state = state.copyWith(error: 'You have already purchased this course');
      return;
    }

    // Check if free course
    if (course.isFree) {
      state = state.copyWith(error: 'Cannot add free courses to cart');
      return;
    }

    final newItem = CartItemModel(
      id: course.id.toString(),
      course: course,
      addedAt: DateTime.now(),
    );

    state = state.copyWith(items: [...state.items, newItem], error: null);
  }

  // Remove course from cart
  void removeFromCart(int courseId) {
    state = state.copyWith(
      items: state.items.where((item) => item.course.id != courseId).toList(),
      error: null,
    );
  }

  // Clear cart
  void clearCart() {
    state = state.copyWith(items: [], error: null);
  }

  // Create order
  Future<void> createOrder() async {
    if (state.items.isEmpty) {
      state = state.copyWith(error: 'Cart is empty');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final courseIds = state.items.map((item) => item.course.id).toList();

      final response = await _orderRepository.createOrder(courseIds);

      state = state.copyWith(
        isLoading: false,
        lastOrder: response,
        items: [], // Clear cart after successful order
        error: null,
      );
    } on DioException catch (e) {
      String errorMessage = 'Connection error';
      if (e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unexpected error occurred',
      );
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Clear last order
  void clearLastOrder() {
    state = state.copyWith(lastOrder: null);
  }
}

// Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final orderRepository = getIt<OrderRepository>();
  return CartNotifier(orderRepository);
});

// Helper providers
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartTotalPriceProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).totalPrice;
});

final isInCartProvider = Provider.family<bool, int>((ref, courseId) {
  return ref.watch(cartProvider).isInCart(courseId);
});
