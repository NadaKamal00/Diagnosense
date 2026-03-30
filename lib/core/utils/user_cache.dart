import 'package:shared_preferences/shared_preferences.dart';

/// A centralized, static cache for all user profile data.
///
/// All screens and services MUST use these constants and methods
/// instead of raw string keys to ensure consistency.
///
/// USAGE:
///   // Save
///   await UserCache.saveUserData(name: 'Alice', email: '...', phone: '...');
///
///   // Read
///   final name = await UserCache.getName();
class UserCache {
  UserCache._(); // Prevent instantiation

  // ──────────────────────────────────────────
  // Key Constants (Single Source of Truth)
  // ──────────────────────────────────────────
  static const String keyName = 'user_name';
  static const String keyEmail = 'user_email';
  static const String keyPhone = 'user_phone';
  static const String keyToken = 'auth_token'; // aliased as 'user_token' per spec

  // ──────────────────────────────────────────
  // Write
  // ──────────────────────────────────────────

  /// Saves user profile fields to SharedPreferences.
  /// Call this after any successful login or profile update.
  static Future<void> saveUserData({
    String? name,
    String? email,
    String? phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString(keyName, name);
    if (email != null) await prefs.setString(keyEmail, email);
    if (phone != null) await prefs.setString(keyPhone, phone);
  }

  /// Saves the auth token to SharedPreferences.
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
  }

  /// Clears all user data from SharedPreferences (use on logout).
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyName);
    await prefs.remove(keyEmail);
    await prefs.remove(keyPhone);
    await prefs.remove(keyToken);
  }

  // ──────────────────────────────────────────
  // Read
  // ──────────────────────────────────────────

  /// Returns the cached user name, or null if not set.
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyName);
  }

  /// Returns the cached user email, or null if not set.
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyEmail);
  }

  /// Returns the cached user phone, or null if not set.
  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyPhone);
  }

  /// Returns the cached auth token, or null if not set.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  /// Reads all user profile fields in a single SharedPreferences instance.
  /// More efficient than calling getName/getEmail/getPhone separately.
  static Future<Map<String, String?>> getAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      keyName: prefs.getString(keyName),
      keyEmail: prefs.getString(keyEmail),
      keyPhone: prefs.getString(keyPhone),
    };
  }
}
