import 'package:yuna/core/network/models/paginated_data.dart';
import '../../data/models/category_model.dart';
import '../../data/models/sub_category_model.dart';
import '../../data/models/course_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/add_review_request.dart';

abstract class CoursesRepository {
  Future<PaginatedData<CategoryModel>> getCategories({
    String? search,
    int? perPage,
    int? page,
  });

  Future<PaginatedData<SubCategoryModel>> getSubCategories({
    int? categoryId,
    String? search,
    int? perPage,
    int? page,
  });

  Future<PaginatedData<CourseModel>> getCourses({
    int? subCategoryId,
    int? instructorId,
    bool? isFree,
    String? search,
    int? perPage,
    int? page,
  });

  Future<PaginatedData<CourseModel>> getMyCourses({int? perPage, int? page});

  // getLessons works for both guest and authenticated users
  // Token is automatically added by Dio interceptor if user is logged in
  Future<PaginatedData<LessonModel>> getLessons({
    int? courseId,
    bool? isFree,
    String? search,
    int? perPage,
    int? page,
  });

  Future<void> markLessonCompleted(int lessonId);

  Future<void> markLessonIncomplete(int lessonId);

  Future<void> updateProgress(int lessonId, double progress);

  Future<void> addReview(AddReviewRequest request);
}
