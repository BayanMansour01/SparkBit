import '../errors/error_handler.dart';
import '../errors/failure.dart';
import '../models/app_constants.dart';
import '../network/api/constants_api.dart';

class ConstantsRepository {
  final ConstantsApi _api;

  ConstantsRepository(this._api);

  Future<AppConstants> getConstants() async {
    try {
      final response = await _api.getConstants();
      if (response.data == null) throw ServerFailure(response.message);
      return response.data!.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
