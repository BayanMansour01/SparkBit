import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_profile.dart';
import '../../../courses/data/models/category_model.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../courses/presentation/providers/courses_provider.dart';
import '../../../../core/network/models/paginated_data.dart';
import '../../../../core/network/models/pagination_model.dart';
import '../../../../core/services/logger_service.dart';

class HomeData {
  final UserProfile userProfile;
  final List<CourseModel> popularCourses;
  final List<CategoryModel> categories;
  final List<CourseModel> myCourses;

  HomeData({
    required this.userProfile,
    required this.popularCourses,
    required this.categories,
    required this.myCourses,
  });
}

/// Home data provider - aggregates data from multiple providers
/// This provider watches other providers and rebuilds automatically when they change
/// Individual providers (coursesProvider, myCoursesProvider) handle their own caching
final homeDataProvider = FutureProvider<HomeData>((ref) async {
  // Get user profile first to determine current user state
  // This must be watched first so that if userProfile changes, this provider rebuilds
  final userProfile = await ref.watch(userProfileProvider.future);
  final isGuest = userProfile.id == -1;

  // Execute requests in parallel
  // Skip my-courses for guests
  final futures = <Future>[
    Future.value(userProfile), // Already fetched
    ref.watch(homePopularCoursesProvider.future), // Use home-specific provider
    ref.watch(homeCategoriesProvider.future), // Use home-specific provider
    if (!isGuest)
      ref.watch(myCoursesProvider.future).catchError((e) {
        LoggerService.logToFile('Failed to fetch my courses in Home: $e');
        return PaginatedData<CourseModel>(
          data: <CourseModel>[],
          pagination: const PaginationModel(
            total: 0,
            perPage: 0,
            currentPage: 1,
            lastPage: 1,
            from: 0,
            to: 0,
          ),
        );
      }),
  ];

  final results = await Future.wait(futures);

  return HomeData(
    userProfile: results[0] as UserProfile,
    popularCourses: (results[1] as PaginatedData<CourseModel>).data,
    categories: (results[2] as PaginatedData<CategoryModel>).data,
    myCourses: isGuest
        ? [] // Empty list for guests
        : (results[3] as PaginatedData<CourseModel>).data,
  );
});

/// Manual refresh function
/// Call this when user explicitly pulls to refresh
void refreshHomeData(WidgetRef ref) {
  ref.invalidate(homeDataProvider);
  ref.invalidate(userProfileProvider);
  ref.invalidate(homePopularCoursesProvider); // Use home-specific provider
  ref.invalidate(homeCategoriesProvider); // Use home-specific provider
  ref.invalidate(myCoursesProvider);
}
