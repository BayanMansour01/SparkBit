import '../../../../core/errors/error_handler.dart';
import '../datasources/app_config_remote_datasource.dart';
import '../models/app_config_model.dart';
import '../../domain/repositories/app_config_repository.dart';

/// Implementation of AppConfigRepository (Data Layer)
/// This is the concrete implementation that connects to the data source
class AppConfigRepositoryImpl implements AppConfigRepository {
  final AppConfigRemoteDataSource _remoteDataSource;

  AppConfigRepositoryImpl(this._remoteDataSource);

  @override
  Future<AppConfigModel> getConfig() async {
    try {
      return await _remoteDataSource.getConfig();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
