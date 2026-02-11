import 'package:yuna/core/network/models/paginated_data.dart';
import '../../data/models/lesson_model.dart';
import '../repositories/courses_repository.dart';

/// GetLessonsUseCase works for both guest and authenticated users.
/// The token is automatically added by Dio interceptor if the user is logged in.
class GetLessonsUseCase {
  final CoursesRepository _repository;

  GetLessonsUseCase(this._repository);

  Future<PaginatedData<LessonModel>> call({
    int? courseId,
    bool? isFree,
    String? search,
    int? perPage,
    int? page,
  }) async {
    return await _repository.getLessons(
      courseId: courseId,
      isFree: isFree,
      search: search,
      perPage: perPage,
      page: page,
    );
  }
}
