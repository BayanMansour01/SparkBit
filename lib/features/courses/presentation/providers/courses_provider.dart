import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/models/paginated_data.dart';
import '../../data/models/category_model.dart';
import '../../data/models/sub_category_model.dart';
import '../../data/models/course_model.dart';
import '../../data/models/lesson_model.dart';
import '../../domain/repositories/courses_repository.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_sub_categories_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/get_lessons_usecase.dart';

/// Provider for CoursesRepository
final coursesRepositoryProvider = Provider<CoursesRepository>((ref) {
  return getIt<CoursesRepository>();
});

/// Provider for GetCategoriesUseCase
final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.watch(coursesRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

/// Provider for GetSubCategoriesUseCase
final getSubCategoriesUseCaseProvider = Provider<GetSubCategoriesUseCase>((
  ref,
) {
  final repository = ref.watch(coursesRepositoryProvider);
  return GetSubCategoriesUseCase(repository);
});

/// Provider for GetCoursesUseCase
final getCoursesUseCaseProvider = Provider<GetCoursesUseCase>((ref) {
  final repository = ref.watch(coursesRepositoryProvider);
  return GetCoursesUseCase(repository);
});

/// Provider for GetLessonsUseCase
final getLessonsUseCaseProvider = Provider<GetLessonsUseCase>((ref) {
  final repository = ref.watch(coursesRepositoryProvider);
  return GetLessonsUseCase(repository);
});

/// Lessons Provider (Auto-fetching lessons for a course)
/// Lessons Notifier for managing lessons state
class LessonsNotifier
    extends AutoDisposeFamilyAsyncNotifier<PaginatedData<LessonModel>, int> {
  @override
  Future<PaginatedData<LessonModel>> build(int courseId) async {
    final useCase = ref.watch(getLessonsUseCaseProvider);
    return await useCase(courseId: courseId, perPage: 100);
  }

  /// Optimistic Update: Manually update lesson state in the list
  void updateLocalState(int lessonId, {bool? isCompleted, double? progress}) {
    if (!state.hasValue || state.value == null) return;

    final currentData = state.value!;
    final updatedList = currentData.data.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(
          isCompleted: isCompleted ?? lesson.isCompleted,
          progress: progress ?? lesson.progress,
        );
      }
      return lesson;
    }).toList();

    state = AsyncValue.data(currentData.copyWith(data: updatedList));
  }

  /// Optimistic Update: Update lesson avg rating locally after a review
  void updateLessonRating(int lessonId, double newRating) {
    if (!state.hasValue || state.value == null) return;

    final currentData = state.value!;
    final updatedList = currentData.data.map((lesson) {
      if (lesson.id == lessonId) {
        // If lesson had no rating, use the new rating directly
        // If it had a rating, average it (approximate until API returns real value)
        final currentRating = lesson.avgRating ?? 0;
        final updatedRating = currentRating == 0
            ? newRating
            : (currentRating + newRating) / 2;
        return lesson.copyWith(avgRating: updatedRating);
      }
      return lesson;
    }).toList();

    state = AsyncValue.data(currentData.copyWith(data: updatedList));
  }

  /// Silent Refresh: Fetch fresh data from API without clearing current state
  Future<void> refreshData() async {
    try {
      final useCase = ref.read(getLessonsUseCaseProvider);
      final newData = await useCase(
        courseId: arg, // arg is courseId in FamilyNotifier
        perPage: 100,
      );
      state = AsyncValue.data(newData);
    } catch (e) {
      // Keep old state on error or handle gracefully
    }
  }
}

final lessonsProvider = AsyncNotifierProvider.autoDispose
    .family<LessonsNotifier, PaginatedData<LessonModel>, int>(
      LessonsNotifier.new,
    );

// --- STATE ---

/// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Selected category ID state provider (null means 'All' or none selected)
final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);

/// Selected sub-category ID state provider
final selectedSubCategoryIdProvider = StateProvider<int?>((ref) => null);

// --- HOME PAGE PROVIDERS (No Search/Filter) ---

/// Categories Provider for Home Page (no search/filter)
class HomeCategoriesNotifier
    extends AsyncNotifier<PaginatedData<CategoryModel>> {
  @override
  Future<PaginatedData<CategoryModel>> build() async {
    ref.keepAlive();
    final useCase = ref.watch(getCategoriesUseCaseProvider);
    return await useCase(search: '', perPage: 10, page: 1);
  }
}

final homeCategoriesProvider =
    AsyncNotifierProvider<HomeCategoriesNotifier, PaginatedData<CategoryModel>>(
      HomeCategoriesNotifier.new,
    );

/// Popular Courses Provider for Home Page (no search/filter)
class HomePopularCoursesNotifier
    extends AsyncNotifier<PaginatedData<CourseModel>> {
  @override
  Future<PaginatedData<CourseModel>> build() async {
    ref.keepAlive();
    final useCase = ref.watch(getCoursesUseCaseProvider);
    return await useCase(subCategoryId: null, search: '', perPage: 15, page: 1);
  }
}

final homePopularCoursesProvider =
    AsyncNotifierProvider<
      HomePopularCoursesNotifier,
      PaginatedData<CourseModel>
    >(HomePopularCoursesNotifier.new);

// --- NOTIFIERS ---

class CategoriesNotifier extends AsyncNotifier<PaginatedData<CategoryModel>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String _lastSearch = '';

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<PaginatedData<CategoryModel>> build() async {
    ref.keepAlive();
    final search = ref.watch(searchQueryProvider);

    // 🚀 SMART CACHING: Only fetch if search changed or no data exists
    if (state.hasValue && state.value != null && search == _lastSearch) {
      return state.value!;
    }

    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    _lastSearch = search;

    final useCase = ref.watch(getCategoriesUseCaseProvider);
    final result = await useCase(search: search, perPage: 10, page: 1);

    _hasMore = result.pagination.currentPage < result.pagination.lastPage;

    return result;
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoadingMore || state.isLoading || state.value == null) {
      return;
    }

    _isLoadingMore = true;
    try {
      final search = ref.read(searchQueryProvider);
      final useCase = ref.read(getCategoriesUseCaseProvider);
      final nextPage = _page + 1;

      final newData = await useCase(
        search: search,
        perPage: 10,
        page: nextPage,
      );

      _page = nextPage;
      _hasMore = newData.pagination.currentPage < newData.pagination.lastPage;

      final currentData = state.value!;
      state = AsyncValue.data(
        currentData.copyWith(
          data: [...currentData.data, ...newData.data],
          pagination: newData.pagination,
        ),
      );
    } catch (e) {
      // Handle error
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Force refresh data (bypass cache)
  Future<void> forceRefresh() async {
    _lastSearch = ''; // Reset cache
    ref.invalidateSelf();
  }
}

class SubCategoriesNotifier
    extends AsyncNotifier<PaginatedData<SubCategoryModel>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String _lastSearch = '';
  int? _lastCategoryId;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<PaginatedData<SubCategoryModel>> build() async {
    ref.keepAlive();
    final search = ref.watch(searchQueryProvider);
    final categoryId = ref.watch(selectedCategoryIdProvider);

    // 🚀 SMART CACHING: Only fetch if search/category changed or no data exists
    if (state.hasValue &&
        state.value != null &&
        search == _lastSearch &&
        categoryId == _lastCategoryId) {
      return state.value!;
    }

    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    _lastSearch = search;
    _lastCategoryId = categoryId;

    final useCase = ref.watch(getSubCategoriesUseCaseProvider);
    final result = await useCase(
      categoryId: categoryId,
      search: search,
      perPage: 10,
      page: 1,
    );

    _hasMore = result.pagination.currentPage < result.pagination.lastPage;

    return result;
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoadingMore || state.isLoading || state.value == null) {
      return;
    }

    _isLoadingMore = true;
    try {
      final search = ref.read(searchQueryProvider);
      final categoryId = ref.read(selectedCategoryIdProvider);
      final useCase = ref.read(getSubCategoriesUseCaseProvider);
      final nextPage = _page + 1;

      final newData = await useCase(
        categoryId: categoryId,
        search: search,
        perPage: 10,
        page: nextPage,
      );

      _page = nextPage;
      _hasMore = newData.pagination.currentPage < newData.pagination.lastPage;

      final currentData = state.value!;
      state = AsyncValue.data(
        currentData.copyWith(
          data: [...currentData.data, ...newData.data],
          pagination: newData.pagination,
        ),
      );
    } catch (e) {
      // Handle error
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Force refresh data (bypass cache)
  Future<void> forceRefresh() async {
    _lastSearch = '';
    _lastCategoryId = null;
    ref.invalidateSelf();
  }
}

class CoursesNotifier extends AsyncNotifier<PaginatedData<CourseModel>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String _lastSearch = '';
  int? _lastSubCategoryId;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<PaginatedData<CourseModel>> build() async {
    ref.keepAlive();
    final search = ref.watch(searchQueryProvider);
    final subCategoryId = ref.watch(selectedSubCategoryIdProvider);

    // 🚀 SMART CACHING: Only fetch if search/subcategory changed or no data exists
    if (state.hasValue &&
        state.value != null &&
        search == _lastSearch &&
        subCategoryId == _lastSubCategoryId) {
      return state.value!;
    }

    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    _lastSearch = search;
    _lastSubCategoryId = subCategoryId;

    final useCase = ref.watch(getCoursesUseCaseProvider);
    final result = await useCase(
      subCategoryId: subCategoryId,
      search: search,
      perPage: 15,
      page: 1,
    );

    _hasMore = result.pagination.currentPage < result.pagination.lastPage;

    return result;
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoadingMore || state.isLoading || state.value == null) {
      return;
    }

    _isLoadingMore = true;
    try {
      final search = ref.read(searchQueryProvider);
      final subCategoryId = ref.read(selectedSubCategoryIdProvider);
      final useCase = ref.read(getCoursesUseCaseProvider);
      final nextPage = _page + 1;

      final newData = await useCase(
        subCategoryId: subCategoryId,
        search: search,
        perPage: 15,
        page: nextPage,
      );

      _page = nextPage;
      _hasMore = newData.pagination.currentPage < newData.pagination.lastPage;

      final currentData = state.value!;
      state = AsyncValue.data(
        currentData.copyWith(
          data: [...currentData.data, ...newData.data],
          pagination: newData.pagination,
        ),
      );
    } catch (e) {
      // Handle error
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Force refresh data (bypass cache)
  Future<void> forceRefresh() async {
    _lastSearch = '';
    _lastSubCategoryId = null;
    ref.invalidateSelf();
  }

  /// يحدد الدرس كمكتمل بناءً على نوعه:
  /// - إذا كان فيديو: يتم تحديث التقدم إلى 100%
  /// - إذا كان ملفاً فقط: يتم استخدام endpoint الإكمال المباشر
  Future<void> markLessonCompleted(
    LessonModel lesson, {
    double progress = 100.0,
  }) async {
    if (lesson.hasVideo) {
      await updateLessonProgress(lesson.id, progress);
    } else {
      final repository = ref.read(coursesRepositoryProvider);
      await repository.markLessonCompleted(lesson.id);
    }
  }

  Future<void> markLessonIncomplete(int lessonId) async {
    try {
      final repository = ref.read(coursesRepositoryProvider);
      await repository.markLessonIncomplete(lessonId);
    } catch (e) {
      // Silently ignore - user might not be enrolled in the course
      print('Failed to mark lesson incomplete: $e');
    }
  }

  Future<void> updateLessonProgress(int lessonId, double progress) async {
    try {
      final repository = ref.read(coursesRepositoryProvider);
      await repository.updateProgress(lessonId, progress);
    } catch (e) {
      // Silently ignore errors (e.g., 404 if user not enrolled in course)
      // This prevents crashes when browsing courses as guest or when not enrolled
      print('Failed to update lesson progress: $e');
    }
  }

  /// Optimistic Update: Update course progress percentage locally
  void updateCourseLocalProgress(int courseId, int newPercentage) {
    if (!state.hasValue || state.value == null) return;

    final currentData = state.value!;
    final updatedList = currentData.data.map((course) {
      if (course.id == courseId) {
        return course.copyWith(completionPercentage: newPercentage);
      }
      return course;
    }).toList();

    state = AsyncValue.data(currentData.copyWith(data: updatedList));
  }

  /// Silent Refresh
  Future<void> refreshData() async {
    try {
      final search = ref.read(searchQueryProvider);
      final subCategoryId = ref.read(selectedSubCategoryIdProvider);
      final useCase = ref.read(getCoursesUseCaseProvider);

      // Reload first page
      final newData = await useCase(
        subCategoryId: subCategoryId,
        search: search,
        perPage: 15,
        page: 1,
      );

      _page = 1;
      _hasMore = newData.pagination.currentPage < newData.pagination.lastPage;
      state = AsyncValue.data(newData);
    } catch (_) {}
  }
}

// --- PROVIDERS ---

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, PaginatedData<CategoryModel>>(
      CategoriesNotifier.new,
    );

final subCategoriesProvider =
    AsyncNotifierProvider<
      SubCategoriesNotifier,
      PaginatedData<SubCategoryModel>
    >(SubCategoriesNotifier.new);

final coursesProvider =
    AsyncNotifierProvider<CoursesNotifier, PaginatedData<CourseModel>>(
      CoursesNotifier.new,
    );

class MyCoursesNotifier extends AsyncNotifier<PaginatedData<CourseModel>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<PaginatedData<CourseModel>> build() async {
    ref.keepAlive();
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;

    final repository = ref.watch(coursesRepositoryProvider);
    // Use repository directly or create a UseCase. Using repository for simplicity now as per user instruction flow.
    // Ideally should be a UseCase.
    final result = await repository.getMyCourses(perPage: 15, page: 1);

    _hasMore = result.pagination.currentPage < result.pagination.lastPage;

    return result;
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoadingMore || state.isLoading || state.value == null) {
      return;
    }

    _isLoadingMore = true;
    try {
      final repository = ref.read(coursesRepositoryProvider);
      final nextPage = _page + 1;

      final newData = await repository.getMyCourses(
        perPage: 15,
        page: nextPage,
      );

      _page = nextPage;
      _hasMore = newData.pagination.currentPage < newData.pagination.lastPage;

      final currentData = state.value!;
      state = AsyncValue.data(
        currentData.copyWith(
          data: [...currentData.data, ...newData.data],
          pagination: newData.pagination,
        ),
      );
    } catch (e) {
      // Handle error
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Optimistic Update: Update course progress percentage locally
  void updateCourseLocalProgress(int courseId, int newPercentage) {
    if (!state.hasValue || state.value == null) return;

    final currentData = state.value!;
    final updatedList = currentData.data.map((course) {
      if (course.id == courseId) {
        // Create a copy but WITH the new progress.
        // Since CourseModel is freezed/immutable, implement copyWith properly or use the generated one.
        // Assuming copyWith exists from freezed:
        return course.copyWith(completionPercentage: newPercentage);
      }
      return course;
    }).toList();

    state = AsyncValue.data(currentData.copyWith(data: updatedList));
  }

  /// Silent Refresh: Update from API without clearing state
  Future<void> refreshData() async {
    try {
      final repository = ref.read(coursesRepositoryProvider);
      final newData = await repository.getMyCourses(perPage: 15, page: 1);

      _page = 1;
      _hasMore = newData.pagination.currentPage < newData.pagination.lastPage;
      state = AsyncValue.data(newData);
    } catch (_) {}
  }
}

final myCoursesProvider =
    AsyncNotifierProvider<MyCoursesNotifier, PaginatedData<CourseModel>>(
      MyCoursesNotifier.new,
    );

/// Provider to get a specific course by ID from the loaded lists
/// This ensures that when lists are updated (e.g. progress change),
/// the details screen updates automatically.
final courseByIdProvider = Provider.family<CourseModel?, int>((ref, courseId) {
  // Use `ref.read` to get the current state without subscribing to changes.
  // This prevents re-fetching when the UI rebuilds for other reasons.

  // 1. Check My Courses (Priority for progress updates)
  final myCoursesState = ref.read(myCoursesProvider);
  if (myCoursesState.hasValue && myCoursesState.value != null) {
    try {
      return myCoursesState.value!.data.firstWhere((c) => c.id == courseId);
    } catch (_) {}
  }

  // 2. Check All Courses
  final allCoursesState = ref.read(coursesProvider);
  if (allCoursesState.hasValue && allCoursesState.value != null) {
    try {
      return allCoursesState.value!.data.firstWhere((c) => c.id == courseId);
    } catch (_) {}
  }

  return null;
});
