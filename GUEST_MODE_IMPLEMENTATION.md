# 🧑‍💻 Guest Mode & API Authorization Logic

## 1. 🚀 Startup Logic (Splash Screen)
- **Previous Behavior:** If no token found → Go to `SignInScreen`.
- **New Professional Behavior:** If no token found → Go to `HomeScreen` as **Guest**.
- **Implementation:** Updated `splash_screen.dart` to navigate to `AppRoutes.home` on auth failure.

## 2. 🏠 Smart Home Data (Guest vs User)
- **Guest:** Loads `Popular Courses` + `Categories`. Skips `My Courses` API call (0 errors).
- **User:** Loads everything including `My Courses`.
- **Logic:** `HomeData` checks `isGuest` flag before making sensitive API calls.

## 3. 🛒 "Add to Cart" Protection
- The button is **visible** to guests to encourage conversion.
- **Action:** Clicking it triggers a professional dialog explaining "Sign In Required" with a direct button to **Login/Register**.
- **Why:** Immediate redirection can be jarring. A dialog respects user intent while guiding them firmly.

## 4. 📚 Adaptive "My Courses" Tab
- **Guest:** Sees "Browse All Courses" (Full catalog).
- **User:** Sees "My Enrolled Courses".
- **Fix:** Created missing `MyCoursesScreen.dart` which was causing build errors in `AdaptiveCoursesScreen`.

## 5. 🛡️ Robust Error Handling
- **Logout:** Added `try-catch-finally` to ensure local data is wiped even if server is down (503).
- **API Calls:** Guest calls are filtered to prevent 401/403 errors in the logs.

## 6. 💰 Currency Update
- Changed all prices to display in **USD ($)** instead of EGP.
- Updated `AppStrings` constants for global consistency.

## 7. 🚪 Seamless Logout
- **Behavior:** Logging out now redirects to **Home Screen** (as Guest) instead of Sign In screen.
- **Why:** Provide a smoother transition for users who want to browse without an account immediately after logging out.
