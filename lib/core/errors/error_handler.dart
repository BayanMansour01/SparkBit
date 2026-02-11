import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is FormatException) {
      return const ValidationFailure("Data format error");
    } else if (error is Failure) {
        return error;
    } else {
      return UnexpectedFailure(error.toString());
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure("Connection Timeout");
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return const UnexpectedFailure("Request Cancelled");
      case DioExceptionType.connectionError:
        return const NetworkFailure("No Internet Connection");
      default:
        return const UnexpectedFailure("Unknown Network Error");
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) return const ServerFailure("Unknown Protocol Error");
    
    // Try parsing backend message
    try {
      if (response.data is Map<String, dynamic>) {
          final message = response.data['message'] ?? response.statusMessage ?? "Something went wrong";
          return ServerFailure(message, code: response.statusCode);
      }
      return ServerFailure(response.statusMessage ?? "Server Error", code: response.statusCode);
    } catch (_) {
      return ServerFailure("Server Error: ${response.statusCode}", code: response.statusCode);
    }
  }
}
