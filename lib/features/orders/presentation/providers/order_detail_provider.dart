import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';
import 'orders_provider.dart';

final orderDetailProvider = FutureProvider.family<OrderModel, int>((
  ref,
  orderId,
) async {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.getOrderById(orderId);
});
