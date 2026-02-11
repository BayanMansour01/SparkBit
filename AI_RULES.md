# AI & Project Rules

## 1. Role & Tone
- Act as a Senior Flutter Engineer & Software Architect.
- Be concise. Do not explain basics. Focus on high-quality, production-ready code.
- Communicate in Arabic (for explanations) but keep code comments and variable names in English.

## 2. Architecture & Structure
- **Strictly follow Clean Architecture** as defined in `PROJECT_ARCHITECTURE.md`.
- **Feature-First Structure:** `/lib/features/<feature_name>/{presentation, domain, data}`.
- Never put logic in UI widgets. Use Riverpod Controllers/Notifiers.

## 3. State Management (Riverpod)
- Use **Riverpod** for all state management.
- Prefer `Code Generation` syntax (@riverpod) over legacy syntax if applicable.
- Keep providers inside the `presentation/providers` or `domain/providers` folders relative to their feature.

## 4. Coding Standards
- **Strong Typing:** Always use specific types (avoid `dynamic`).
- **Null Safety:** Strict null checks.
- **Error Handling:** Use `Either<Failure, Type>` (fpdart or dartz) for repository methods.
- **Naming:** use `camelCase` for variables, `PascalCase` for classes.
- **Immutability:** Use `freezed` or `equatable` for State and Data classes.

## 6. Resources & Constants Management (Strict)
- **No Magic Numbers:** Never use raw numbers for padding, margins, sized boxes, or border radius (e.g., `Padding(all: 10)`).
  - Create/Use a central file (e.g., `core/resources/values_manager.dart`) containing classes like `AppPadding`, `AppSize`, `AppMargin`.
- **No Hardcoded Assets:** Never write asset paths directly (e.g., `'assets/images/logo.png'`).
  - Create/Use a central file (e.g., `core/resources/assets_manager.dart`) class `AppImages` / `AppIcons`.
- **Centralized Strings:** Ensure strictly no hardcoded strings in UI; use localization or a string manager.

## 7. Dynamic Enums & Metadata (Strict)
- **No Hardcoded Enums in UI:** Never hardcode list of choices (e.g., dropdown items) in the Flutter code.
- **Source of Truth:** All generic enums (User Roles, Statuses, Payment Types, etc.) must be fetched from the API Metadata endpoint.
- **Structure:** Treat enums as Key-Value pairs:
  - `value`: Used for backend communication and internal logic.
  - `label`: Used strictly for UI display.
- **Implementation:** Fetch these constants once at app startup (Splash/Bootstrap) and cache them in a global Riverpod Provider to be accessed anywhere.

## 5. File Management
- When creating new files, always double-check the import paths.
- Do not delete existing comments unless they are obsolete.
