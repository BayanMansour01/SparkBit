import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../errors/failure.dart';
import '../errors/error_handler.dart';
import '../models/app_constants.dart';
import '../network/api/constants_api.dart';
import '../repositories/app_constants_repository.dart';

class AppConstantsRepositoryImpl implements AppConstantsRepository {
  final ConstantsApi _api;

  AppConstantsRepositoryImpl(this._api);

  @override
  Future<Either<Failure, AppConstants>> getAppConstants() async {
    try {
      final response = await _api.getConstants();
      if (response.code == 200 && response.data != null) {
        return Right(response.data!.data);
      } else {
        return Left(
          ServerFailure(response.message ?? 'Failed to load constants'),
        );
      }
    } on DioException catch (e) {
      return Left(ErrorHandler.handle(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
