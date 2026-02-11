import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/models/base_response.dart';
import '../models/order_request_model.dart';
import '../models/order_response_model.dart';

part 'cart_remote_datasource.g.dart';

@RestApi()
abstract class CartRemoteDataSource {
  factory CartRemoteDataSource(Dio dio, {String baseUrl}) =
      _CartRemoteDataSource;

  @POST(ApiEndpoints.createOrder)
  Future<BaseResponse<OrderResponseModel>> createOrder(
    @Body() OrderRequestModel orderRequest,
  );
}
