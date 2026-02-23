import 'dart:developer';

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

      // Debug: Print the raw config data
      log('📦 Raw config data from API:');
      log(configData.toString());
      log('  maintenance_mode value: ${configData['maintenance_mode']}');
      log(
        '  maintenance_mode type: ${configData['maintenance_mode'].runtimeType}',
      );

      return AppConfigModel.fromJson(configData);
    } catch (e) {
      log('❌ Error fetching config: $e');
      rethrow;
    }
  }
}
