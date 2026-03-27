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

      final model = AppConfigModel.fromJson(configData);

      log('━━━━━━━━━━ AppConfig loaded from backend ━━━━━━━━━━');
      log(
        '  [RAW]  maintenance_mode     : ${configData['maintenance_mode']} (${configData['maintenance_mode'].runtimeType})',
      );
      log(
        '  [RAW]  latest_android       : ${configData['latest_android_version']}',
      );
      log(
        '  [RAW]  min_android          : ${configData['latest_supported_android_version']}',
      );
      log(
        '  [RAW]  latest_ios           : ${configData['latest_ios_version']}',
      );
      log(
        '  [RAW]  min_ios              : ${configData['latest_supported_ios_version']}',
      );
      log('  ─────────────────────────────────────────────────');
      log('  [PARSED]  isMaintenance     : ${model.isMaintenance}');
      log('  [PARSED]  maintenanceMsg    : ${model.maintenanceMessage}');
      log('  [PARSED]  minVersion        : ${model.minVersion}');
      log('  [PARSED]  latestVersion     : ${model.latestVersion}');
      log('  [PARSED]  updateUrl         : ${model.updateUrl}');
      log('  [PARSED]  directAndroidLink : ${model.directAndroidLink}');
      log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      return model;
    } catch (e) {
      log('❌ Error fetching config: $e');
      rethrow;
    }
  }
}
