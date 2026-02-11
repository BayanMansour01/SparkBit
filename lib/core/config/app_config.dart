/// ═══════════════════════════════════════════════════════════════════════════
/// APPLICATION CONFIGURATION
/// ═══════════════════════════════════════════════════════════════════════════
///
/// Central configuration file for app-wide settings.
/// Toggle flags here to switch between development and production modes.
///
/// Author: Antigravity AI
/// ═══════════════════════════════════════════════════════════════════════════
library app_config;

class AppConfig {
  AppConfig._();

  // ═══════════════════════════════════════════════════════════════════════════
  // MOCK DATA CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Master toggle for mock data across all repositories.
  ///
  /// When `true`:
  /// - All repositories will return mock data instead of calling APIs
  /// - Useful for development, testing, and offline demos
  ///
  /// When `false`:
  /// - All repositories will call real APIs
  /// - This is the production setting
  static const bool useMockData = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // API CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Simulated network delay for mock data (milliseconds)
  /// Makes mock data feel more realistic during development
  static const int mockNetworkDelayMs = 800;

  /// Enable/disable debug logging for API calls
  static const bool enableApiLogging = true;

  // ═══════════════════════════════════════════════════════════════════════════
  // FEATURE FLAGS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Enable/disable guest mode browsing
  static const bool enableGuestMode = true;

  /// Enable/disable cart functionality
  static const bool enableCart = true;

  /// Enable/disable notifications
  static const bool enableNotifications = true;
}
