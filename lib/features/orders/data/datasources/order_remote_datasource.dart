import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/models/paginated_data.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(List<int> courseIds);
  Future<PaginatedData<OrderModel>> getOrders({int? page, int? perPage});
  Future<OrderModel> getOrderById(int orderId);
  Future<void> uploadPaymentProof(int orderId, String filePath);
  Future<void> cancelOrder(int orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<OrderModel> createOrder(List<int> courseIds) async {
    final response = await dio.post(
      ApiEndpoints.createOrder,
      data: {'course_ids': courseIds},
    );
    final dataMap = response.data['data']['data'] as Map<String, dynamic>;
    return OrderModel.fromJson(dataMap);
  }

  @override
  Future<PaginatedData<OrderModel>> getOrders({int? page, int? perPage}) async {
    final response = await dio.get(
      ApiEndpoints.ordersGetAll,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final dataMap = response.data['data'] as Map<String, dynamic>;
    return PaginatedData.fromJson(
      dataMap,
      (json) => OrderModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    final response = await dio.get(
      ApiEndpoints.ordersGetById.replaceAll('{id}', orderId.toString()),
    );
    final dataMap = response.data['data']['data'] as Map<String, dynamic>;
    return OrderModel.fromJson(dataMap);
  }

  @override
  Future<void> uploadPaymentProof(int orderId, String filePath) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'payment_proof': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    await dio.post(
      ApiEndpoints.uploadPaymentProof.replaceAll('{id}', orderId.toString()),
      data: formData,
    );
  }

  @override
  Future<void> cancelOrder(int orderId) async {
    await dio.post(
      ApiEndpoints.cancelOrder.replaceAll('{id}', orderId.toString()),
    );
  }
}
