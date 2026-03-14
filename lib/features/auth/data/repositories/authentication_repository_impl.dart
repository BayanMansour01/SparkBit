import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/mock_data.dart';
import '../../../../core/models/user_profile.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/authentication_remote_datasource.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;
  final GoogleSignIn googleSignIn;
  final SharedPreferences sharedPreferences;

  static const String tokenKey = 'access_token';
  static const String currentUserIdKey = 'current_user_id';

  AuthenticationRepositoryImpl({
    required this.remoteDataSource,
    required this.googleSignIn,
    required this.sharedPreferences,
  });

  @override
  Future<UserProfile> loginWithGoogle() async {
    // ═══════════════════════════════════════════════════════════════════════════
    // MOCK DATA MODE
    // ═══════════════════════════════════════════════════════════════════════════
    if (AppConfig.useMockData) {
      await MockData.simulateNetworkDelay();

      // Save dummy token for mock session
      await sharedPreferences.setString(tokenKey, 'mock_access_token_123');
      await sharedPreferences.setInt(currentUserIdKey, MockData.mockProfile.id);

      return MockData.mockProfile;
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // REAL API MODE
    // ═══════════════════════════════════════════════════════════════════════════
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign In Cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        throw Exception('Failed to get Google Access Token');
      }

      final authResponse = await remoteDataSource.googleLogin(accessToken);

      // Save access token
      await sharedPreferences.setString(tokenKey, authResponse.accessToken);
      await sharedPreferences.setInt(currentUserIdKey, authResponse.user.id);

      return authResponse.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (!AppConfig.useMockData) {
        await remoteDataSource.logout();
      }
    } catch (_) {
      // Ignore API errors on logout
    } finally {
      await clearLocalSession();
    }
  }

  @override
  Future<void> clearLocalSession() async {
    if (!AppConfig.useMockData) {
      try {
        // Prevent hanging if Google Sign In is stuck
        await googleSignIn.signOut().timeout(const Duration(seconds: 2));
      } catch (_) {
        // Ignore timeout or other errors, we just want to proceed clearing local data
      }
    }
    await sharedPreferences.remove(tokenKey);
    await sharedPreferences.remove(currentUserIdKey);
  }
}
