import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/authentication_response.dart';

abstract class AuthenticationRemoteDataSource {
  Future<AuthenticationResponse> googleLogin(String accessToken);
  Future<void> logout();
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final Dio dio;

  AuthenticationRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthenticationResponse> googleLogin(String accessToken) async {
    final response = await dio.post(
      ApiEndpoints.googleLogin,
      data: {'access_token': accessToken},
    );

    // Manual parsing since we are not using Retrofit here for simplicity or
    // because existing pattern uses manual parsing in some places.
    // Structure: BaseResponse<DataWrapper<AuthenticationResponse>>
    final dataMap = response.data['data']['data'] as Map<String, dynamic>;
    return AuthenticationResponse.fromJson(dataMap);
  }

  @override
  Future<void> logout() async {
    await dio.post(ApiEndpoints.logout);
  }
}
