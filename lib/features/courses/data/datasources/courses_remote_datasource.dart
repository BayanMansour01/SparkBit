import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/models/base_response.dart';
import '../../../../core/network/models/paginated_data.dart';
import '../models/category_model.dart';
import '../models/sub_category_model.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';

part 'courses_remote_datasource.g.dart';

@RestApi()
abstract class CoursesRemoteDataSource {
  factory CoursesRemoteDataSource(Dio dio, {String baseUrl}) =
      _CoursesRemoteDataSource;

  @GET(ApiEndpoints.studentCategoriesGetAll)
  Future<BaseResponse<PaginatedData<CategoryModel>>> getCategories({
    @Query('search') String? search,
    @Query('perPage') int? perPage,
    @Query('page') int? page,
  });

  @GET(ApiEndpoints.studentSubCategoriesGetAll)
  Future<BaseResponse<PaginatedData<SubCategoryModel>>> getSubCategories({
    @Query('category_id') int? categoryId,
    @Query('search') String? search,
    @Query('perPage') int? perPage,
    @Query('page') int? page,
  });

  @GET(ApiEndpoints.studentCoursesGetAll)
  Future<BaseResponse<PaginatedData<CourseModel>>> getCourses({
    @Query('sub_category_id') int? subCategoryId,
    @Query('instructor_id') int? instructorId,
    @Query('is_free') bool? isFree,
    @Query('search') String? search,
    @Query('perPage') int? perPage,
    @Query('page') int? page,
  });

  @GET(ApiEndpoints.studentMyCourses)
  Future<BaseResponse<PaginatedData<CourseModel>>> getMyCourses({
    @Query('perPage') int? perPage,
    @Query('page') int? page,
  });

  // Lessons - Token is automatically added by interceptor if user is logged in
  @GET(ApiEndpoints.studentLessonsGetAll)
  Future<BaseResponse<PaginatedData<LessonModel>>> getLessons({
    @Query('course_id') int? courseId,
    @Query('is_free') bool? isFree,
    @Query('search') String? search,
    @Query('perPage') int? perPage,
    @Query('page') int? page,
  });

  @POST(ApiEndpoints.markLessonCompleted)
  Future<BaseResponse> markLessonCompleted(@Path('id') int lessonId);

  @POST(ApiEndpoints.markLessonIncomplete)
  Future<BaseResponse> markLessonIncomplete(@Path('id') int lessonId);

  @POST(ApiEndpoints.updateProgress)
  Future<BaseResponse> updateProgress(
    @Path('id') int lessonId,
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.addReview)
  Future<BaseResponse> addReview(@Body() Map<String, dynamic> body);
}
