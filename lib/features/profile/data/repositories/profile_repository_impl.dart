import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/mock_data.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/models/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserProfile> getProfile() async {
    // Mock Mode
    if (AppConfig.useMockData) {
      await MockData.simulateNetworkDelay();
      return MockData.mockProfile;
    }

    try {
      final response = await _remoteDataSource.getProfile();
      if (response.data == null) {
        throw ServerFailure(response.message);
      }
      return response.data!.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<UserProfile> updateProfile(String? name, [String? avatarPath]) async {
    // Mock Mode
    if (AppConfig.useMockData) {
      await MockData.simulateNetworkDelay();
      return MockData.mockProfile.copyWith(name: name ?? MockData.mockProfile.name);
    }

    try {
      MultipartFile? avatarFile;
      if (avatarPath != null && avatarPath.isNotEmpty) {
        avatarFile = await MultipartFile.fromFile(avatarPath);
      }

      final response = await _remoteDataSource.updateProfile(
        name: name,
        avatar: avatarFile,
      );

      if (response.data == null) {
        throw ServerFailure(response.message);
      }
      return response.data!.data;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
