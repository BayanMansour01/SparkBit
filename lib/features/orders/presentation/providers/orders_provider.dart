import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/models/paginated_data.dart';
import '../../data/models/order_model.dart';
import '../../domain/repositories/order_repository.dart';

// Provider for OrderRepository
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return getIt<OrderRepository>();
});

final ordersProvider =
    AsyncNotifierProvider<OrdersNotifier, PaginatedData<OrderModel>>(
      OrdersNotifier.new,
    );

class OrdersNotifier extends AsyncNotifier<PaginatedData<OrderModel>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<PaginatedData<OrderModel>> build() async {
    ref.keepAlive();
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;

    final repository = ref.watch(orderRepositoryProvider);
    final result = await repository.getOrders(page: 1, perPage: 15);

    _hasMore = result.pagination.currentPage < result.pagination.lastPage;

    return result;
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoadingMore || state.isLoading || state.value == null) {
      return;
    }

    _isLoadingMore = true;
    try {
      final repository = ref.read(orderRepositoryProvider);
      final nextPage = _page + 1;

      final newData = await repository.getOrders(page: nextPage, perPage: 15);

      _page = nextPage;
      _hasMore = newData.pagination.currentPage < newData.pagination.lastPage;

      final currentData = state.value!;
      state = AsyncValue.data(
        currentData.copyWith(
          data: [...currentData.data, ...newData.data],
          pagination: newData.pagination,
        ),
      );
    } catch (e) {
      // Handle error
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
    await future;
  }

  Future<void> cancelOrder(int orderId) async {
    final repository = ref.read(orderRepositoryProvider);
    await repository.cancelOrder(orderId);
    await refresh();
  }

  Future<void> uploadPaymentProof(int orderId, String filePath) async {
    final repository = ref.read(orderRepositoryProvider);
    await repository.uploadPaymentProof(orderId, filePath);
    await refresh();
  }
}
