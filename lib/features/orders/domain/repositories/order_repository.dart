import 'package:yuna/core/network/models/paginated_data.dart';
import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel> createOrder(List<int> courseIds);
  
  Future<PaginatedData<OrderModel>> getOrders({
    int? page,
    int? perPage,
  });
  
  Future<OrderModel> getOrderById(int orderId);

  Future<void> uploadPaymentProof(int orderId, String filePath);
  
  Future<void> cancelOrder(int orderId);
}
