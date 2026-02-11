import '../../data/models/app_config_model.dart';
import '../repositories/app_config_repository.dart';

/// Use case for getting app configuration
/// This encapsulates the business logic for fetching configuration
class GetAppConfigUseCase {
  final AppConfigRepository _repository;

  GetAppConfigUseCase(this._repository);

  /// Execute the use case
  Future<AppConfigModel> call() async {
    return await _repository.getConfig();
  }
}
