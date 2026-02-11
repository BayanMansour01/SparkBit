import '../../data/models/app_config_model.dart';

/// Domain repository interface for app configuration
/// This defines the contract that the data layer must implement
abstract class AppConfigRepository {
  /// Fetch app configuration from remote source
  Future<AppConfigModel> getConfig();
}
