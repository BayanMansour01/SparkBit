import '../../../../core/models/user_profile.dart';

abstract class AuthenticationRepository {
  Future<UserProfile> loginWithGoogle();
  Future<void> logout();
  Future<void> clearLocalSession();
}
