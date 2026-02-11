# 💰 Currency & Logout Fixes update

## 1. 💱 Currency Unification
All app prices strictly use **EGP** now.
To ensure consistency, we introduced a centralized helper:
`AppStrings.formatPrice(dynamic price)`

### Usage:
```dart
// Works with String, double, or int
Text(AppStrings.formatPrice(course.price)); // "EGP 1500"
Text(AppStrings.formatPrice(120.50));       // "EGP 120.50"
```

### Updated Files:
- `AppStrings` (Added currency constants)
- `CartItemCard`
- `OrderSummaryWidget`
- `CheckoutScreen`
- `CourseDetailsScreen`
- `CartSummaryCard`

---

## 2. 🛒 Guest "Add to Cart" Logic
The "Add to Cart" button is now **visible** for guests.
- **Action:** Clicking it shows a "Sign In Required" dialog.
- **Goal:** Improve conversion by showing guests what they can buy, then prompting signup.

---

## 3. 🚪 Logout Error Fix (503/404)
**Problem:** Logging out caused a cascade of API errors (503 Service Unavailable, then 404s).
**Cause:** The app was trying to fetch protected user data (like `my-courses`) *after* the token was invalidated but *before* the local state was cleared.

**Fix:**
Implemented a **Safe Logout Sequence** in `ProfileScreen`:
1.  **Try API Logout:** Attempt to notify server.
2.  **Catch Errors:** If server fails (503), ignore it and proceed.
3.  **Deep Clean (Finally):**
    - Invalidate `userProfileProvider`
    - Invalidate `myCoursesProvider`
    - Invalidate `coursesProvider`
    - Invalidate `cartProvider`
    - Invalidate `homeDataProvider`
4.  **Force Navigate:** Go to Sign In screen immediately.

```dart
try {
  await auth.logout();
} catch (e) {
  print('Server error ignored');
} finally {
  ref.invalidate(allProviders); // ✨ Magic Fix
  context.go(AppRoutes.signIn);
}
```

This ensures no protected API calls are made with an invalid token.
