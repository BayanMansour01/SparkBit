import '../../../../core/models/user_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<UserProfile> call() async {
    return await _repository.getProfile();
  }
}
