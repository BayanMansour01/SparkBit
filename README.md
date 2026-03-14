# Sparkbit Flutter App

Sparkbit is a Flutter learning platform app using a clean, feature-first architecture with Riverpod, GetIt, and GoRouter.

## Tech Stack

- Flutter
- Riverpod (manual providers)
- GetIt (dependency injection)
- Dio + Retrofit (network)
- Freezed + json_serializable (models)
- GoRouter (navigation)
- SharedPreferences (local persistence)

## Architecture

The project follows Clean Architecture and feature-first organization:

```text
lib/
	core/
	features/
		<feature>/
			data/
			domain/
			presentation/
	router/
```

Main data flow:

```text
UI (Riverpod) -> UseCase -> Repository -> RemoteDataSource
```

## Getting Started

### 1. Prerequisites

- Flutter SDK installed
- Dart SDK (bundled with Flutter)
- Android Studio or VS Code
- A configured emulator/device

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

## Useful Developer Commands

### Analyze

```bash
flutter analyze
```

### Format

```bash
dart format .
```

### Code Generation

Run this after updating Freezed, json_serializable, or Retrofit models/apis:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Project Conventions

- Use manual Riverpod providers (do not use @riverpod code generation style).
- Keep business logic outside UI widgets.
- Use theme colors, avoid hardcoded colors where possible.
- Keep repository/use-case boundaries clear.

## Notes

- Some repositories support mock data toggles. If API behavior looks unexpected, check feature repository implementations first.
- Auth and session-sensitive behavior (for example user-scoped cart) is already implemented and should be preserved when refactoring.

## Optional: Copilot Jumpstart Prompt

If you want GitHub Copilot coding agent to scaffold improvements in this repo, you can use:

```text
Build production-ready Flutter improvements for this existing Sparkbit app using the current Clean Architecture + feature-first structure, Riverpod manual providers, GetIt DI, and GoRouter patterns.

Goals:
1) Improve startup performance by prefetching Home data during Splash without duplicate API calls.
2) Unify loading UX with reusable shimmer/skeleton components that match real UI layouts.
3) Strengthen responsive behavior for 320, 360, 390, 768, and 1024 widths.
4) Standardize network image loading with AppNetworkImage (fade-in + shimmer + fallback).
5) Fix Orders and Order Details UX edge cases, including payment proof flow and loading overlays.

Constraints:
- Do not introduce new state management libraries.
- Preserve existing route contracts and API behavior.
- Keep changes focused and minimal.

Validation:
- flutter analyze on changed files.
- No runtime layout exceptions from nested/unbounded scroll views.
- Include a short QA checklist in the PR.
```

## Flutter Resources

- Flutter docs: https://docs.flutter.dev/
- Codelabs: https://docs.flutter.dev/get-started/codelab
- Cookbook: https://docs.flutter.dev/cookbook
