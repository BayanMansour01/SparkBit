import 'package:get_it/get_it.dart';
// import 'package:dio/dio.dart';

/// Global GetIt instance
final getIt = GetIt.instance;

/// Initialize all dependencies
/// Call this in main.dart before runApp()
Future<void> initDependencies() async {
  // ============================================================
  // CORE
  // ============================================================
  
  // TODO: Uncomment when needed
  // getIt.registerLazySingleton<Dio>(() => DioFactory.create());

  // ============================================================
  // DATA SOURCES
  // ============================================================
  
  // TODO: Register remote data sources
  // getIt.registerLazySingleton<CoursesRemoteDataSource>(
  //   () => CoursesRemoteDataSource(getIt<Dio>()),
  // );

  // ============================================================
  // REPOSITORIES
  // ============================================================
  
  // TODO: Register repository implementations
  // getIt.registerLazySingleton<CoursesRepository>(
  //   () => CoursesRepositoryImpl(getIt<CoursesRemoteDataSource>()),
  // );

  // ============================================================
  // USE CASES
  // ============================================================
  
  // TODO: Register use cases
  // getIt.registerLazySingleton<GetCoursesUseCase>(
  //   () => GetCoursesUseCase(getIt<CoursesRepository>()),
  // );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
