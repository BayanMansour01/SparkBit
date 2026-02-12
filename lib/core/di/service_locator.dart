import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yuna/core/repositories/app_constants_repository.dart';
import 'package:yuna/core/repositories/app_constants_repository_impl.dart';
import '../../features/app_config/data/datasources/app_config_remote_datasource.dart';
import '../../features/app_config/data/repositories/app_config_repository_impl.dart';
import '../../features/app_config/domain/repositories/app_config_repository.dart';
import '../../features/courses/data/datasources/courses_remote_datasource.dart';
import '../../features/courses/data/repositories/courses_repository_impl.dart';
import '../../features/courses/domain/repositories/courses_repository.dart';
import '../../features/courses/domain/usecases/get_categories_usecase.dart';
import '../../features/courses/domain/usecases/get_sub_categories_usecase.dart';
import '../../features/courses/domain/usecases/get_courses_usecase.dart';
import '../../features/courses/domain/usecases/get_lessons_usecase.dart';
import '../../features/courses/domain/usecases/add_review_usecase.dart';

import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/auth/data/datasources/authentication_remote_datasource.dart';
import '../../features/auth/data/repositories/authentication_repository_impl.dart';
import '../../features/auth/domain/repositories/authentication_repository.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/orders/data/datasources/order_remote_datasource.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/contact_us/domain/repositories/contact_repository.dart';
import '../../features/contact_us/data/repositories/contact_repository_impl.dart';
import '../network/api/student_api.dart';
import '../network/api/constants_api.dart';
import '../network/dio_client.dart';
import '../services/device_service.dart';
import '../services/firebase_messaging_service.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> setupServiceLocator() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // External - Google Sign In
  getIt.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      scopes: ['email', 'profile'],

      // For Android without google-services.json, you may need to configure OAuth 2.0 client in Android manifest
      // and optionally provide serverClientId for backend token validation
      serverClientId:
          '1043932528193-1036b19s1c09jcr2kqh2mcskabjekpo9.apps.googleusercontent.com',
    ),
  );

  // Dio
  getIt.registerLazySingleton<Dio>(
    () => DioClient.createDio(getIt<SharedPreferences>()),
  );

  // APIs & Data Sources
  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AppConfigRemoteDataSource>(
    () => AppConfigRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CoursesRemoteDataSource>(
    () => CoursesRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<StudentApi>(() => StudentApi(getIt<Dio>()));
  getIt.registerLazySingleton<ConstantsApi>(() => ConstantsApi(getIt<Dio>()));

  // Services
  getIt.registerLazySingleton<FirebaseMessagingService>(
    () => FirebaseMessagingService(),
  );
  getIt.registerLazySingleton<DeviceService>(
    () => DeviceService(
      getIt<StudentApi>(),
      getIt<SharedPreferences>(),
      getIt<FirebaseMessagingService>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      remoteDataSource: getIt<AuthenticationRemoteDataSource>(),
      googleSignIn: getIt<GoogleSignIn>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );
  getIt.registerLazySingleton<AppConfigRepository>(
    () => AppConfigRepositoryImpl(getIt<AppConfigRemoteDataSource>()),
  );
  getIt.registerLazySingleton<CoursesRepository>(
    () => CoursesRepositoryImpl(getIt<CoursesRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton<AppConstantsRepository>(
    () => AppConstantsRepositoryImpl(getIt<ConstantsApi>()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt<StudentApi>()),
  );
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(getIt<OrderRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(getIt<StudentApi>()),
  );

  // UseCases
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<CoursesRepository>()),
  );
  getIt.registerLazySingleton<GetSubCategoriesUseCase>(
    () => GetSubCategoriesUseCase(getIt<CoursesRepository>()),
  );
  getIt.registerLazySingleton<GetCoursesUseCase>(
    () => GetCoursesUseCase(getIt<CoursesRepository>()),
  );
  getIt.registerLazySingleton<GetLessonsUseCase>(
    () => GetLessonsUseCase(getIt<CoursesRepository>()),
  );

  getIt.registerLazySingleton<AddReviewUseCase>(
    () => AddReviewUseCase(getIt<CoursesRepository>()),
  );

  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<ProfileRepository>()),
  );
}
