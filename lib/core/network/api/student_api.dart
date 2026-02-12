import 'package:dio/dio.dart';
import '../../models/user_profile.dart';
import '../../models/app_constants.dart';
import '../api_endpoints.dart';
import '../models/paginated_data.dart';
import '../../../features/notifications/data/models/notification_model.dart';
import '../../../features/contact_us/data/models/contact_method_model.dart';

/// API service for student-related endpoints
class StudentApi {
  final Dio dio;

  StudentApi(this.dio);

  /// Get student profile
  Future<UserProfile> getProfile() async {
    final response = await dio.get(ApiEndpoints.studentProfile);
    final responseData = response.data as Map<String, dynamic>;
    final profileData = responseData['data']['data'] as Map<String, dynamic>;
    return UserProfile.fromJson(profileData);
  }

  /// Get app constants
  Future<AppConstants> getConstants() async {
    final response = await dio.get(ApiEndpoints.studentConstants);
    final responseData = response.data as Map<String, dynamic>;
    final constantsData = responseData['data']['data'] as Map<String, dynamic>;
    return AppConstants.fromJson(constantsData);
  }

  /// Update or create user device
  Future<void> updateOrCreateDevice({
    required String fcmToken,
    required String deviceType,
    required String deviceInfo,
  }) async {
    await dio.post(
      ApiEndpoints.updateOrCreateDevice,
      data: {
        'fcm_token': fcmToken,
        'device_type': deviceType,
        'device_info': deviceInfo,
      },
    );
  }

  /// Get notifications
  Future<PaginatedData<NotificationModel>> getNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await dio.get(
      ApiEndpoints.notificationsGetAll,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;
    return PaginatedData.fromJson(
      data,
      (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get unread notifications count
  Future<int> getUnreadCount() async {
    final response = await dio.get(ApiEndpoints.notificationsUnreadCount);
    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as Map<String, dynamic>;
    final innerData = data['data'] as Map<String, dynamic>;
    return innerData['unread_count'] as int;
  }

  /// Get contact methods
  Future<List<ContactMethodModel>> getContactMethods() async {
    final response = await dio.get(ApiEndpoints.contactUsGetAll);
    final responseData = response.data as Map<String, dynamic>;
    final data = responseData['data'] as List<dynamic>;
    return data
        .map(
          (json) => ContactMethodModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
