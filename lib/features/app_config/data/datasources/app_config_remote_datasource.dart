import 'package:dio/dio.dart';
import '../models/app_config_model.dart';
import '../../../../core/network/api_endpoints.dart';

/// Remote data source for app configuration
/// This handles all API calls related to app config
abstract class AppConfigRemoteDataSource {
  Future<AppConfigModel> getConfig();
}

class AppConfigRemoteDataSourceImpl implements AppConfigRemoteDataSource {
  final Dio dio;

  AppConfigRemoteDataSourceImpl(this.dio);

  @override
  Future<AppConfigModel> getConfig() async {
    try {
      final response = await dio.get(ApiEndpoints.studentSettings);
      final responseData = response.data as Map<String, dynamic>;
      final configData = responseData['data']['data'] as Map<String, dynamic>;
      return AppConfigModel.fromJson(configData);
    } catch (e) {
      rethrow;
    }
  }
}
