import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:yuna/core/network/models/base_response.dart';
import 'package:yuna/core/network/models/data_wrapper.dart';
import '../../models/app_constants.dart';

part 'constants_api.g.dart';

@RestApi()
abstract class ConstantsApi {
  factory ConstantsApi(Dio dio, {String baseUrl}) = _ConstantsApi;

  @GET('/api/student/constants')
  Future<BaseResponse<DataWrapper<AppConstants>>> getConstants();
}
