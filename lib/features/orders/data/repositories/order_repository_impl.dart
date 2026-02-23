import 'package:sparkbit/core/network/models/paginated_data.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<OrderModel> createOrder(List<int> courseIds) {
    return remoteDataSource.createOrder(courseIds);
  }

  @override
  Future<PaginatedData<OrderModel>> getOrders({int? page, int? perPage}) {
    return remoteDataSource.getOrders(page: page, perPage: perPage);
  }

  @override
  Future<OrderModel> getOrderById(int orderId) {
    return remoteDataSource.getOrderById(orderId);
  }

  @override
  Future<void> uploadPaymentProof(int orderId, String filePath) {
    return remoteDataSource.uploadPaymentProof(orderId, filePath);
  }

  @override
  Future<void> cancelOrder(int orderId) {
    return remoteDataSource.cancelOrder(orderId);
  }
}
