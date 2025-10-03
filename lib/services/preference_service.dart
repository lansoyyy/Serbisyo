import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String _keyOnboardingSeen = 'onboarding_seen';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPassword = 'user_password';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Onboarding preferences
  static bool hasSeenOnboarding() {
    return _prefs?.getBool(_keyOnboardingSeen) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingSeen, true);
  }

  static Future<void> clearOnboardingPreference() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingSeen, false);
  }

  // Auto-login preferences
  static bool getRememberMe() {
    return _prefs?.getBool(_keyRememberMe) ?? false;
  }

  static Future<void> setRememberMe(bool value) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, value);
  }

  static String? getUserEmail() {
    return _prefs?.getString(_keyUserEmail);
  }

  static Future<void> setUserEmail(String email) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  static String? getUserPassword() {
    return _prefs?.getString(_keyUserPassword);
  }

  static Future<void> setUserPassword(String password) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(_keyUserPassword, password);
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  // Save user session for auto-login
  static Future<void> saveUserSession({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, rememberMe);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserPassword, password);
    await prefs.setBool(_keyIsLoggedIn, true);
    print(
        'PreferenceService: Session saved - Email: $email, RememberMe: $rememberMe');
  }

  // Clear user session (for logout)
  static Future<void> clearUserSession() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.remove(_keyRememberMe);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPassword);
    await prefs.setBool(_keyIsLoggedIn, false);
    print('PreferenceService: Session cleared');
  }

  // Get saved credentials for auto-login
  static Map<String, dynamic>? getSavedCredentials() {
    final rememberMe = getRememberMe();
    final loggedIn = isLoggedIn();
    final email = getUserEmail();
    final password = getUserPassword();

    print(
        'PreferenceService: getSavedCredentials - RememberMe: $rememberMe, IsLoggedIn: $loggedIn, Email: $email');

    if (!rememberMe || !loggedIn) return null;

    return {
      'email': email,
      'password': password,
    };
  }
}
