import 'package:equatable/equatable.dart';

/// Abstract class to define Failure types
/// Equatable is used so we can compare Failures (e.g. in tests)
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

// General Server Failure (API Errors)
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

// Cache Failure (Local DB Errors)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Network Failure (No Internet)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection']);
}

// Validation Failure (User Input Errors)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Unexpected Failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Unexpected Error Occurred']);
}
