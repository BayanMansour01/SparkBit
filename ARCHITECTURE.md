# 🏗️ Clean Architecture + Feature-First Structure

This project follows **Clean Architecture** principles with a **Feature-First** approach.

## 📁 Project Structure

```
lib/
├── core/                          # Shared/Common layer for the entire app
│   ├── constants/                # App-wide constants
│   ├── di/                       # Dependency Injection (GetIt)
│   ├── errors/                   # Common error handling
│   ├── models/                   # Shared models (user, device, constants)
│   ├── network/                  # Network configuration (Dio, interceptors)
│   ├── providers/                # Global Riverpod providers
│   ├── services/                 # Global services
│   ├── theme/                    # App theming
│   ├── utils/                    # Utility functions
│   └── widgets/                  # Reusable widgets
│
├── features/                      # Feature modules
│   │
│   ├── app_config/               # ✅ App Configuration Feature
│   │   ├── data/                 # Data Layer
│   │   │   ├── datasources/      # Remote/Local data sources
│   │   │   │   └── app_config_remote_datasource.dart
│   │   │   ├── models/           # Data models (DTOs)
│   │   │   │   └── app_config_model.dart
│   │   │   └── repositories/     # Repository implementations
│   │   │       └── app_config_repository_impl.dart
│   │   │
│   │   ├── domain/               # Domain Layer (Business Logic)
│   │   │   ├── entities/         # Domain entities (if needed)
│   │   │   ├── repositories/     # Repository interfaces
│   │   │   │   └── app_config_repository.dart
│   │   │   └── usecases/         # Use cases
│   │   │       └── get_app_config_usecase.dart
│   │   │
│   │   └── presentation/         # Presentation Layer
│   │       ├── providers/        # Feature-specific providers
│   │       │   └── app_config_provider.dart
│   │       ├── screens/          # UI screens
│   │       │   ├── maintenance_screen.dart
│   │       │   └── update_required_screen.dart
│   │       └── widgets/          # Feature-specific widgets
│   │           └── app_config_wrapper.dart
│   │
│   ├── auth/                     # ✅ Authentication Feature
│   │   ├── data/                 # Data Layer
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/               # Domain Layer
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/         # Presentation Layer
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── courses/                  # ✅ Courses Feature (Already properly structured)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       └── screens/
│   │
│   ├── home/                     # Home Feature
│   ├── profile/                  # Profile Feature
│   ├── saved/                    # Saved Items Feature
│   └── settings/                 # Settings Feature
│
├── router/                        # App routing
└── main.dart                      # App entry point
```

## 🎯 Clean Architecture Layers

### 1️⃣ **Data Layer** (الطبقة الخارجية)
- **Purpose**: Handles all data operations
- **Contains**:
  - `datasources/`: API calls, local storage, etc.
  - `models/`: Data Transfer Objects (DTOs) with JSON serialization
  - `repositories/`: Concrete implementations of repository interfaces

### 2️⃣ **Domain Layer** (الطبقة الوسطى - Business Logic)
- **Purpose**: Contains business logic, independent of framework/UI
- **Contains**:
  - `entities/`: Pure business objects (optional, can use models)
  - `repositories/`: Abstract repository interfaces
  - `usecases/`: Business logic operations

### 3️⃣ **Presentation Layer** (الطبقة الداخلية)
- **Purpose**: UI and state management
- **Contains**:
  - `providers/`: Riverpod providers for state management
  - `screens/`: Full-page UI widgets
  - `widgets/`: Feature-specific reusable widgets

## 📐 Dependency Rule

**Dependencies point inward**:
```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain  
- Domain depends on nothing (pure Dart)

## ✅ Completed Features

- ✅ **app_config**: Fully restructured with Data, Domain, and Presentation layers
- ✅ **courses**: Already following clean architecture
- 🔄 **auth**: Folders created, ready for implementation
- 📝 **home, profile, saved, settings**: Simple features (may not need full layers)

## 🔧 Dependency Injection

Uses **GetIt** for dependency injection (`core/di/service_locator.dart`):

```dart
// Data Sources
getIt.registerLazySingleton<AppConfigRemoteDataSource>(
  () => AppConfigRemoteDataSourceImpl(getIt<Dio>()),
);

// Repositories
getIt.registerLazySingleton<AppConfigRepository>(
  () => AppConfigRepositoryImpl(getIt<AppConfigRemoteDataSource>()),
);
```

## 🔄 Data Flow Example (app_config feature)

```
User Action (UI)
    ↓
Provider calls UseCase
    ↓
GetAppConfigUseCase
    ↓  
AppConfigRepository (interface)
    ↓
AppConfigRepositoryImpl
    ↓
AppConfigRemoteDataSource
    ↓
API Call (Dio)
    ↓
Response → Model → back through layers
```

## 📝 Best Practices

1. **Feature Independence**: Each feature is self-contained
2. **Single Responsibility**: Each layer has one job
3. **Testability**: Easy to mock and test each layer
4. **Scalability**: Easy to add new features
5. **Maintainability**: Clear separation of concerns

## 🚀 Adding a New Feature

1. Create feature folder in `lib/features/your_feature`
2. Add three layer folders: `data/`, `domain/`, `presentation/`
3. Implement from Domain → Data → Presentation
4. Register dependencies in `service_locator.dart`
5. Use providers to connect to UI

---

**Author**: Antigravity AI  
**Date**: 2026-01-22  
**Architecture**: Clean Architecture + Feature-First
