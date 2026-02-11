import 'package:dartz/dartz.dart';
import '../errors/failure.dart';
import '../models/app_constants.dart';

abstract class AppConstantsRepository {
  Future<Either<Failure, AppConstants>> getAppConstants();
}
