/// API Endpoints
/// Contains all API endpoints used in the application
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseURl = "http://10.184.210.95:8000";
  // Student Settings
  static const String studentSettings = '/student/settings/getAll';

  // Auth
  static const String googleLogin = '/student/auth/google';
  static const String logout = '/student/auth/logout';

  // Student Profile
  static const String studentProfile = '/student/profile';
  static const String profileUpdate = '/student/profile/update';

  // App Constants
  static const String studentConstants = '/student/constants';

  // User Devices
  static const String updateOrCreateDevice =
      '/student/user-devices/updateOrCreate';

  // Categories
  static const String studentCategoriesGetAll = '/student/categories/getAll';

  // Sub Categories
  static const String studentSubCategoriesGetAll =
      '/student/sub-categories/getAll';

  // Courses
  static const String studentCoursesGetAll = '/student/courses/getAll';
  static const String studentMyCourses = '/student/courses/my-courses';

  // Lessons - Same endpoint works for both guest and logged-in users
  // Token is automatically added by Dio interceptor if available
  static const String studentLessonsGetAll = '/student/lessons/getAll';
  static const String markLessonCompleted =
      '/student/lessons/{id}/mark-completed';
  static const String markLessonIncomplete =
      '/student/lessons/{id}/mark-incomplete';
  static const String updateProgress = '/student/lessons/{id}/update-progress';
  static const String addReview = '/student/reviews';

  // Notifications
  static const String notificationsGetAll = '/student/notifications/getAll';
  static const String notificationsUnreadCount =
      '/student/notifications/unread-count';

  // Orders
  static const String createOrder = '/student/orders/create';
  static const String ordersGetAll = '/student/orders/getAll';
  static const String ordersGetById = '/student/orders/getById/{id}';
  static const String uploadPaymentProof =
      '/student/orders/{id}/upload-payment-proof';
  static const String cancelOrder = '/student/orders/{id}/cancel';

  // Contact Us
  static const String contactUsGetAll = '/student/contact-us/getAll';
}
