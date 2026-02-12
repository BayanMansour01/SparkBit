import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuna/core/network/api_endpoints.dart';
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

    // Authentication Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Use hardcoded token if missing? User showed explicit token in previous context, but likely wants dynamic now.
          // If user provided a token in DioClient previously, maybe it was for testing.
          // I'll stick to dynamic.
          return handler.next(options);
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
