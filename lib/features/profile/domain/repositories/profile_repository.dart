import '../../../../core/models/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(String? name, [String? avatarPath]);
}
