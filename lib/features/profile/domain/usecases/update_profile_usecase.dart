import '../../../../core/models/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<UserProfile> call(String? name, [String? avatarPath]) async {
    return await _repository.updateProfile(name, avatarPath);
  }
}
