import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';
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

    try {
      final responseData = response.data as Map<String, dynamic>;

      // Laravel API Resources sometimes wrap data multiple times
      // We try to find the level that contains 'user' or 'access_token'
      Map<String, dynamic>? dataMap;

      if (responseData.containsKey('user') ||
          responseData.containsKey('access_token')) {
        dataMap = responseData;
      } else if (responseData['data'] != null &&
          responseData['data'] is Map<String, dynamic>) {
        final level1 = responseData['data'] as Map<String, dynamic>;
        if (level1.containsKey('user') || level1.containsKey('access_token')) {
          dataMap = level1;
        } else if (level1['data'] != null &&
            level1['data'] is Map<String, dynamic>) {
          dataMap = level1['data'] as Map<String, dynamic>;
        }
      }

      if (dataMap == null) {
        throw Exception(
          'Could not find authentication data in response structure',
        );
      }

      // Check for nulls in expected fields before passing to fromJson
      if (dataMap['access_token'] == null) {
        log('⚠️ [WARNING] access_token is null in API response');
      }
      if (dataMap['user'] == null) {
        log('⚠️ [WARNING] user object is null in API response');
      }

      return AuthenticationResponse.fromJson(dataMap);
    } catch (e, stack) {
      log('❌ Google Login Error: $e');
      debugPrint('📦 Full Response Data: ${response.data}');
      debugPrint('📚 Stack Trace: $stack');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await dio.post(ApiEndpoints.logout);
  }
}
