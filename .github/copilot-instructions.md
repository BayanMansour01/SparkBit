# Yuna Flutter App - Copilot Instructions

## 🏛️ Big Picture Architecture

- **Clean Architecture + Feature-First**: Code is organized by feature (`lib/features/<feature>/`) containing `data`, `domain`, and `presentation` layers.
- **Hybrid Dependency Injection**:
  - **GetIt**: Used for "Singleton" style services, Repositories, and Data Sources. Defined in `lib/core/di/service_locator.dart`.
  - **Riverpod**: Used for UI binding, Use Cases, and formatting data for widgets. Providers often read from `GetIt` (e.g., `ref.watch(repoProvider)` which calls `getIt<Repo>()`).
- **Navigation flow**: `GoRouter` manages navigation. `StatefulShellRoute.indexedStack` handles the bottom navigation bar.
- **Data Flow**: `UI (Riverpod)` -> `UseCase` -> `Repository` -> `RemoteDataSource` (Retrofit/Dio).

## 🧩 Project-Specific Conventions

### State Management (Riverpod)

- Use **manual provider definition** (e.g., `final myProvider = Provider(...)`), NOT the `@riverpod` code generation syntax.
- Use `FutureProvider.family` for fetching data with arguments.
- Connect UseCases to Repositories via providers in `presentation/providers`.

### Data Layer

- **Mock Data Toggle**: Repositories (e.g., `CoursesRepositoryImpl`) often contain a `static const bool useMockData = true;` flag. Check this flag before debugging API issues.
- **Models**: Use `Freezed` unions with `json_serializable`. Remember to run `dart run build_runner build` after editing models.
- **API**: Wrapped in `BaseResponse<T>`.

### UI & Navigation

- **Hiding Bottom Nav**: To hide the bottom navigation bar on specific screens (e.g., details pages), use `parentNavigatorKey: rootNavigatorKey` in the `GoRoute` definition in `app_router.dart`.
- **Theme**: Themes are defined in `lib/core/theme`. Switch themes using `themeModeProvider`.

## 🛠️ Developer Workflow

- **Codegen**: Run `dart run build_runner build --delete-conflicting-outputs` to regenerate Freezed/Json/Retrofit files.
- **Networking**: `DioClient` (`lib/core/network/dio_client.dart`) handles the Bearer token automatically from SharedPreferences.
- **Environment**: If API calls fail, check if `useMockData` is `true` in the relevant Repository Implementation.

## ⚠️ Common Pitfalls to Avoid

- **Do not** introduce `GetX` or other state management libraries. Stick to Riverpod.
- **Do not** put business logic in UI widgets. Use UseCases and Providers.
- **Do not** hardcode colors. Use `Theme.of(context).colorScheme` or app-specific constants.

## 📂 Key File Locations

- **DI Setup**: [lib/core/di/service_locator.dart](lib/core/di/service_locator.dart)
- **Routes**: [lib/router/app_router.dart](lib/router/app_router.dart)
- **Dio Client**: [lib/core/network/dio_client.dart](lib/core/network/dio_client.dart)
- **Example Feature Structure**: [lib/features/courses](lib/features/courses)
