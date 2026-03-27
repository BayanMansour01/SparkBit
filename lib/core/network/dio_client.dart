import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparkbit/core/network/api_endpoints.dart';
import '../services/logger_service.dart';

/// Dio client configuration
class DioClient {
  static Dio createDio(SharedPreferences prefs) {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${ApiEndpoints.baseURl}/api',
        // baseUrl: 'https://spinescent-wiley-mannered.ngrok-free.dev/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Authentication Interceptor — attaches token to every request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          log('token: ${token.toString()}');
          return handler.next(options);
        },
      ),
    );

    // 401 Auto-Logout Interceptor
    // If any API returns 401 (Unauthorized / token expired), clear the local
    // session so that all providers reload without a token → guest/login state.
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            LoggerService.logToFile(
              '🔐 [401] Token expired or invalid — clearing local session',
            );
            await prefs.remove('access_token');
          }
          return handler.next(e);
        },
      ),
    );

    // Detailed Logging Interceptor (Console + File)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          LoggerService.logToFile(
            '🚀 [REQUEST] ${options.method} ${options.uri}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          LoggerService.logToFile(
            '✅ [RESPONSE] ${response.requestOptions.uri} Status: ${response.statusCode}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          LoggerService.logToFile(
            '❌ [ERROR] ${e.requestOptions.uri} Status: ${e.response?.statusCode} Error: ${e.message}',
          );
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
