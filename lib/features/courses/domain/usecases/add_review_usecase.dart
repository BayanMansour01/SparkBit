import '../repositories/courses_repository.dart';
import '../../data/models/add_review_request.dart';

class AddReviewUseCase {
  final CoursesRepository _repository;

  AddReviewUseCase(this._repository);

  Future<void> call(AddReviewRequest request) {
    return _repository.addReview(request);
  }
}
