import '../../../../core/network/models/paginated_data.dart';
import '../../data/models/course_model.dart';
import '../repositories/courses_repository.dart';

class GetCoursesUseCase {
  final CoursesRepository _repository;

  GetCoursesUseCase(this._repository);

  Future<PaginatedData<CourseModel>> call({
    int? subCategoryId,
    int? instructorId,
    bool? isFree,
    String? search,
    int? perPage,
    int? page,
  }) async {
    return await _repository.getCourses(
      subCategoryId: subCategoryId,
      instructorId: instructorId,
      isFree: isFree,
      search: search,
      perPage: perPage,
      page: page,
    );
  }
}
