/// App route names and paths
///
/// This file contains all route paths and names used in the app.
/// Every route defined here MUST have a corresponding GoRoute in app_router.dart.
class AppRoutes {
  AppRoutes._();

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTE PATHS
  // ═══════════════════════════════════════════════════════════════════════════

  // Auth Routes
  static const String splash = '/';
  static const String signIn = '/sign-in';

  // Main Navigation Routes (Bottom Nav)
  static const String home = '/home';
  static const String myCourses = '/my-courses';
  static const String profile = '/profile';

  static const String cartPath = '/cart';
  static const String cartName = 'cart';
 
  // Home Sub-Routes (relative paths)
  static const String categories = 'categories';
  static const String subCategories = 'sub-categories';

  // Profile Sub-Routes (relative path)
  static const String editProfileRelative = 'edit';

  // Courses Routes
  static const String courses = '/courses';
  static const String allCourses = '/all-courses';
  static const String courseDetails = '/courses/details';
  static const String lessonViewer = '/courses/lesson';

  // Other Routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTE NAMES (for named navigation with context.goNamed)
  // ═══════════════════════════════════════════════════════════════════════════

  // Auth
  static const String splashName = 'splash';
  static const String signInName = 'signIn';

  // Main Navigation
  static const String homeName = 'home';
  static const String myCoursesName = 'myCourses';
  static const String profileName = 'profile';

  // Home Sub-Routes
  static const String categoriesName = 'categories';
  static const String subCategoriesName = 'subCategories';

  // Profile Sub-Routes
  static const String editProfileName = 'editProfile';

  // Courses
  static const String coursesName = 'courses';
  static const String allCoursesName = 'allCourses';
  static const String courseDetailsName = 'courseDetails';
  static const String lessonViewerName = 'lessonViewer';

  // Other
  static const String settingsName = 'settings';
  static const String notificationsName = 'notifications';
  static const String ordersName = 'orders';
  static const String orders = '/orders';
  static const String checkout = '/checkout';
  static const String orderDetailsRelative = 'details/:id';
  static const String orderDetailsName = 'orderDetails';
  static const String checkoutName = 'checkout';
}
