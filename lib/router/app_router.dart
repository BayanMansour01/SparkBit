import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sparkbit/features/cart/presentation/screens/cart_screen.dart';
import 'package:sparkbit/features/orders/presentation/screens/orders_screen.dart';
import '../core/constants/app_routes.dart';
import '../features/orders/presentation/screens/order_detail_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/courses/presentation/screens/courses_screen.dart';
import '../features/courses/presentation/screens/course_details_screen.dart';
import '../features/courses/presentation/screens/lesson_viewer_screen.dart';
import '../features/courses/data/models/course_model.dart';
import '../features/courses/data/models/lesson_model.dart';
import '../features/courses/data/models/category_model.dart'; // Added
import '../features/courses/presentation/screens/sub_categories_screen.dart'; // Added
import '../features/courses/presentation/screens/categories_screen.dart'; // Added
import '../core/widgets/adaptive_courses_screen.dart'; // Adaptive screen
// import '../features/saved/presentation/screens/saved_screen.dart'; // Added
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../core/widgets/main_wrapper.dart'; // Added
import '../features/cart/presentation/screens/checkout_screen.dart';

class AppRouter {
  AppRouter._();

  /// Root navigator key for routes that should cover the bottom nav bar
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  /// GoRouter configuration
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Sign In
      GoRoute(
        path: AppRoutes.signIn,
        name: AppRoutes.signInName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignInScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Application Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.homeName,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
                routes: [
                  GoRoute(
                    path: AppRoutes.subCategories,
                    name: AppRoutes.subCategoriesName,
                    parentNavigatorKey: rootNavigatorKey, // Hide navbar
                    builder: (context, state) => SubCategoriesScreen(
                      category: state.extra as CategoryModel,
                    ),
                  ),
                  GoRoute(
                    path: AppRoutes.categories,
                    name: AppRoutes.categoriesName,
                    parentNavigatorKey: rootNavigatorKey, // Hide navbar
                    builder: (context, state) => const CategoriesScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Courses/My Courses Branch (Adaptive - Navbar Tab)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myCourses,
                name: AppRoutes.myCoursesName,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: AdaptiveCoursesScreen()),
              ),
            ],
          ),

          // Profile Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: AppRoutes.profileName,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
                routes: [
                  GoRoute(
                    path: AppRoutes.editProfileRelative,
                    name: AppRoutes.editProfileName,
                    parentNavigatorKey: rootNavigatorKey, // Hide navbar
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Settings (Fullscreen)
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          },
        ),
      ),

      // Notifications
      GoRoute(
        path: AppRoutes.notifications,
        name: AppRoutes.notificationsName,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Checkout
      GoRoute(
        path: AppRoutes.checkout,
        name: AppRoutes.checkoutName,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),

      // My Orders - New
      GoRoute(
        path: AppRoutes.orders,
        name: AppRoutes.ordersName,
        parentNavigatorKey: rootNavigatorKey, // Full screen, hide nav bar
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OrdersScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0), // Slide from right
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            );
          },
        ),
        routes: [
          GoRoute(
            path: AppRoutes.orderDetailsRelative,
            name: AppRoutes.orderDetailsName,
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) {
              final orderId = int.parse(state.pathParameters['id']!);
              return OrderDetailScreen(orderId: orderId);
            },
          ),
        ],
      ),

      // Courses (Browse - accessed from Home Search or SubCategories)
      GoRoute(
        path: AppRoutes.courses,
        name: AppRoutes.coursesName,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CoursesScreen(),
      ),

      // All Courses (Browse - accessed from Home)
      GoRoute(
        path: AppRoutes.allCourses,
        name: AppRoutes.allCoursesName,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CoursesScreen(),
      ),

      // Course Details (Standalone - can be accessed from anywhere)
      GoRoute(
        path: AppRoutes.courseDetails,
        name: AppRoutes.courseDetailsName,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            CourseDetailsScreen(course: state.extra as CourseModel),
      ),

      // Lesson Viewer (Standalone - can be accessed from anywhere)
      GoRoute(
        path: AppRoutes.lessonViewer,
        name: AppRoutes.lessonViewerName,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            LessonViewerScreen(lesson: state.extra as LessonModel),
      ),
      GoRoute(
        path: AppRoutes.cartPath,
        name: AppRoutes.cartName,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CartScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // حركة انزلاق من الأسفل للأعلى (مثل التطبيقات الاحترافية)
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ),
    ],

    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
