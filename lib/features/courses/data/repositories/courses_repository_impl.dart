import 'package:flutter/foundation.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/models/paginated_data.dart';
import '../../../../core/network/models/pagination_model.dart';
import '../../../../core/utils/mock_data.dart';
import '../../domain/repositories/courses_repository.dart';
import '../datasources/courses_remote_datasource.dart';
import '../models/category_model.dart';
import '../models/course_model.dart';
import '../models/sub_category_model.dart';
import '../models/lesson_model.dart';
import '../models/add_review_request.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// COURSES REPOSITORY IMPLEMENTATION
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Implements [CoursesRepository] with support for both real API and mock data.
/// Toggle [AppConfig.useMockData] to switch between modes.
///
/// Author: Antigravity AI
/// ═══════════════════════════════════════════════════════════════════════════

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesRemoteDataSource _remoteDataSource;

  CoursesRepositoryImpl(this._remoteDataSource);

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<PaginatedData<CategoryModel>> getCategories({
    String? search,
    int? perPage,
    int? page,
  }) async {
    // Real API Mode
    if (!AppConfig.useMockData) {
      final response = await _remoteDataSource.getCategories(
        search: search,
        perPage: perPage,
        page: page,
      );
      if (response.data != null) {
        final categories = response.data!;
        debugPrint('══════════ CATEGORIES FROM BACKEND ══════════');
        debugPrint('Total: ${categories.data.length}');
        for (final cat in categories.data) {
          debugPrint(
            '  [${cat.id}] ${cat.name} → image_url: "${cat.imageUrl}"',
          );
        }
        debugPrint('═════════════════════════════════════════════');
        return categories;
      }
      throw Exception('Categories data is null');
    }

    // Mock Data Mode
    await MockData.simulateNetworkDelay();

    var filtered = MockData.mockCategories;
    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return PaginatedData(
      data: filtered,
      pagination: PaginationModel(
        total: MockData.mockCategories.length,
        perPage: perPage ?? 10,
        currentPage: page ?? 1,
        lastPage: 1,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUB-CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<PaginatedData<SubCategoryModel>> getSubCategories({
    int? categoryId,
    String? search,
    int? perPage,
    int? page,
  }) async {
    // Real API Mode
    if (!AppConfig.useMockData) {
      final response = await _remoteDataSource.getSubCategories(
        categoryId: categoryId,
        search: search,
        perPage: perPage,
        page: page,
      );
      if (response.data != null) {
        return response.data!;
      }
      throw Exception('SubCategories data is null');
    }

    // Mock Data Mode
    await MockData.simulateNetworkDelay();

    var filtered = MockData.mockSubCategories;

    // Filter by category ID
    if (categoryId != null) {
      var categoryFiltered = filtered
          .where((s) => s.categoryId == categoryId)
          .toList();
      // Fallback: If no matches, show some items for demo purposes
      filtered = categoryFiltered.isNotEmpty
          ? categoryFiltered
          : filtered.take(4).toList();
    }

    // Filter by search
    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return PaginatedData(
      data: filtered,
      pagination: PaginationModel(
        total: filtered.length,
        perPage: perPage ?? 10,
        currentPage: page ?? 1,
        lastPage: 1,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COURSES
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<PaginatedData<CourseModel>> getCourses({
    int? subCategoryId,
    int? instructorId,
    bool? isFree,
    String? search,
    int? perPage,
    int? page,
  }) async {
    // Real API Mode
    if (!AppConfig.useMockData) {
      final response = await _remoteDataSource.getCourses(
        subCategoryId: subCategoryId,
        instructorId: instructorId,
        isFree: isFree,
        search: search,
        perPage: perPage,
        page: page,
      );
      return response.data!;
    }

    // Mock Data Mode
    await MockData.simulateNetworkDelay();

    var filtered = MockData.mockCourses;

    // Filter by sub-category
    if (subCategoryId != null) {
      var subFiltered = filtered
          .where((c) => c.subCategoryId == subCategoryId)
          .toList();
      filtered = subFiltered.isNotEmpty ? subFiltered : [];
    }

    // Filter by instructor
    if (instructorId != null) {
      filtered = filtered.where((c) => c.instructorId == instructorId).toList();
    }

    // Filter by free
    if (isFree != null) {
      filtered = filtered.where((c) => c.isFree == isFree).toList();
    }

    // Filter by search
    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where((e) => e.title.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return PaginatedData(
      data: filtered,
      pagination: PaginationModel(
        total: MockData.mockCourses.length,
        perPage: perPage ?? 10,
        currentPage: page ?? 1,
        lastPage: 1,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MY COURSES (Purchased)
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<PaginatedData<CourseModel>> getMyCourses({
    int? perPage,
    int? page,
  }) async {
    // Real API Mode
    if (!AppConfig.useMockData) {
      final response = await _remoteDataSource.getMyCourses(
        perPage: perPage,
        page: page,
      );
      return response.data!;
    }

    // Mock Data Mode
    await MockData.simulateNetworkDelay();

    final myCourses = MockData.mockMyCourses;

    return PaginatedData(
      data: myCourses,
      pagination: PaginationModel(
        total: myCourses.length,
        perPage: perPage ?? 10,
        currentPage: page ?? 1,
        lastPage: 1,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LESSONS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<PaginatedData<LessonModel>> getLessons({
    int? courseId,
    bool? isFree,
    String? search,
    int? perPage,
    int? page,
  }) async {
    // Real API Mode
    if (!AppConfig.useMockData) {
      final response = await _remoteDataSource.getLessons(
        courseId: courseId,
        isFree: isFree,
        search: search,
        perPage: perPage,
        page: page,
      );
      if (response.data != null) {
        return response.data!;
      }
      throw Exception('Lessons data is null');
    }

    // Mock Data Mode
    await MockData.simulateNetworkDelay();

    var filtered = courseId != null
        ? MockData.getLessonsForCourse(courseId)
        : MockData.mockLessons;

    // Filter by free
    if (isFree != null) {
      filtered = filtered.where((l) => l.isFree == isFree).toList();
    }

    // Filter by search
    if (search != null && search.isNotEmpty) {
      filtered = filtered
          .where((l) => l.title.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return PaginatedData(
      data: filtered,
      pagination: PaginationModel(
        total: filtered.length,
        perPage: perPage ?? 20,
        currentPage: page ?? 1,
        lastPage: 1,
        from: 1,
        to: filtered.length,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LESSON PROGRESS ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> markLessonCompleted(int lessonId) async {
    if (!AppConfig.useMockData) {
      await _remoteDataSource.markLessonCompleted(lessonId);
      return;
    }
    await MockData.simulateNetworkDelay();
  }

  @override
  Future<void> markLessonIncomplete(int lessonId) async {
    if (!AppConfig.useMockData) {
      await _remoteDataSource.markLessonIncomplete(lessonId);
      return;
    }
    await MockData.simulateNetworkDelay();
  }

  @override
  Future<void> updateProgress(int lessonId, double progress) async {
    if (!AppConfig.useMockData) {
      await _remoteDataSource.updateProgress(lessonId, {'progress': progress});
      return;
    }
    await MockData.simulateNetworkDelay();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REVIEWS
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Future<void> addReview(AddReviewRequest request) async {
    if (!AppConfig.useMockData) {
      await _remoteDataSource.addReview(request.toJson());
      return;
    }
    await MockData.simulateNetworkDelay();
  }
}
