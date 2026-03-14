import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import '../../../../core/di/service_locator.dart';
import '../../../courses/data/models/course_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../../../features/orders/data/models/order_model.dart';
import '../../../../features/orders/domain/repositories/order_repository.dart';
import 'package:sparkbit/features/orders/presentation/providers/orders_provider.dart';

const String _legacyCartStorageKey = 'cart_items_v1';
const String _tokenScopedCartStoragePrefix = 'cart_items_v2_';
const String _userScopedCartStoragePrefix = 'cart_items_v3_user_';
const String _currentUserIdKey = 'current_user_id';

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
    bool clearLastOrder =
        false, // Sentinel flag to explicitly null out lastOrder
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastOrder: clearLastOrder ? null : (lastOrder ?? this.lastOrder),
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
  final Ref _ref;

  CartNotifier(this._orderRepository, this._ref) : super(CartState()) {
    _loadCartFromStorage();
  }

  bool _isGuest(SharedPreferences prefs) {
    final userId = prefs.getInt(_currentUserIdKey);
    return userId == null || userId <= 0;
  }

  String _buildScopedCartStorageKey(SharedPreferences prefs) {
    final userId = prefs.getInt(_currentUserIdKey);
    if (userId == null || userId <= 0) return '';
    return '$_userScopedCartStoragePrefix$userId';
  }

  String? _buildOldTokenScopedKey(SharedPreferences prefs) {
    final token = prefs.getString('access_token');
    if (token == null || token.isEmpty) return null;
    final tokenHash = sha1.convert(utf8.encode(token)).toString();
    return '$_tokenScopedCartStoragePrefix$tokenHash';
  }

  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = getIt<SharedPreferences>();

      // Guest cart should always start empty and never persist.
      if (_isGuest(prefs)) {
        state = CartState();
        return;
      }

      final scopedKey = _buildScopedCartStorageKey(prefs);
      String? raw = prefs.getString(scopedKey);

      // One-time migration from legacy unscoped key.
      if ((raw == null || raw.isEmpty) &&
          prefs.containsKey(_legacyCartStorageKey)) {
        raw = prefs.getString(_legacyCartStorageKey);
        if (raw != null && raw.isNotEmpty) {
          await prefs.setString(scopedKey, raw);
          await prefs.remove(_legacyCartStorageKey);
        }
      }

      // Migration from old token-scoped keys (v2) to user-scoped key (v3).
      final oldTokenKey = _buildOldTokenScopedKey(prefs);
      if ((raw == null || raw.isEmpty) &&
          oldTokenKey != null &&
          prefs.containsKey(oldTokenKey)) {
        raw = prefs.getString(oldTokenKey);
        if (raw != null && raw.isNotEmpty) {
          await prefs.setString(scopedKey, raw);
          await prefs.remove(oldTokenKey);
        }
      }

      if (raw == null || raw.isEmpty) return;

      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map(
            (item) =>
                CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();

      state = state.copyWith(items: items, error: null);
    } catch (_) {
      // If cache is corrupted, clear it and continue with empty cart.
      final prefs = getIt<SharedPreferences>();
      final scopedKey = _buildScopedCartStorageKey(prefs);
      await prefs.remove(scopedKey);
    }
  }

  Future<void> _persistCartItems() async {
    final prefs = getIt<SharedPreferences>();
    if (_isGuest(prefs)) return;

    final scopedKey = _buildScopedCartStorageKey(prefs);
    final payload = jsonEncode(state.items.map((e) => e.toJson()).toList());
    await prefs.setString(scopedKey, payload);
  }

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

    state = state.copyWith(
      items: [...state.items, newItem],
      error: null,
      lastOrder: null, // Reset lastOrder when adding new items
    );
    _persistCartItems();
  }

  // Remove course from cart
  void removeFromCart(int courseId) {
    state = state.copyWith(
      items: state.items.where((item) => item.course.id != courseId).toList(),
      error: null,
    );
    _persistCartItems();
  }

  // Clear cart
  void clearCart() {
    state = state.copyWith(items: [], error: null);
    _persistCartItems();
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

      // Refresh orders list
      _ref.invalidate(ordersProvider);

      state = state.copyWith(
        isLoading: false,
        lastOrder: response,
        items: [], // Clear cart after successful order
        error: null,
      );
      _persistCartItems();
    } on DioException catch (e) {
      String errorMessage = 'Connection error';
      if (e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        }
      }
      state = state.copyWith(
        isLoading: false,
        items: [], // Clear cart even on failure as requested
        error: errorMessage,
      );
      _persistCartItems();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        items: [], // Clear cart even on failure as requested
        error: 'Unexpected error occurred',
      );
      _persistCartItems();
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Clear last order (uses sentinel flag to allow setting to null)
  void clearLastOrder() {
    state = state.copyWith(clearLastOrder: true);
  }

  // Full reset: clears items + lastOrder + error
  void resetCart() {
    state = CartState(); // Back to fresh initial state
    _persistCartItems();
  }
}

// Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final orderRepository = getIt<OrderRepository>();
  return CartNotifier(orderRepository, ref);
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
