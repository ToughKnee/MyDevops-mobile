import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  // Private constructor
  LocalStorage._privateConstructor(this._prefs);

  // Singleton instance
  static LocalStorage? _instance;

  // Public factory method to get the singleton instance
  static Future<LocalStorage> init() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = LocalStorage._privateConstructor(prefs);
    }
    return _instance!;
  }

  // Factory constructor to get existing instance
  factory LocalStorage() {
    if (_instance == null) {
      throw Exception(
        "LocalStorage not initialized. Call LocalStorage.init() first.",
      );
    }
    return _instance!;
  }

  // Access token
  set accessToken(String token) => _prefs.setString('accessToken', token);
  String get accessToken => _prefs.getString('accessToken') ?? '';

  // Refresh token
  set refreshToken(String token) => _prefs.setString('refreshToken', token);
  String get refreshToken => _prefs.getString('refreshToken') ?? '';

  // User ID
  set userId(String id) => _prefs.setString('userId', id);
  String get userId => _prefs.getString('userId') ?? '';

  // Username
  set username(String username) => _prefs.setString('username', username);
  String get username => _prefs.getString('username') ?? '';

  // User email
  set userEmail(String email) => _prefs.setString('userEmail', email);
  String get userEmail => _prefs.getString('userEmail') ?? '';

  // Check if user is logged in
  bool get isLoggedIn => accessToken.isNotEmpty && userId.isNotEmpty;

  void saveUserData({
    required String id,
    required String username,
    required String email,
    required String token,
  }) {
    userId = id;
    this.username = username;
    userEmail = email;
    accessToken = token;
  }

  // Clear all stored data
  Future<void> clear() async {
    await _prefs.clear();
  }

  // Clear only user-related data
  Future<void> clearUserData() async {
    await _prefs.remove('accessToken');
    await _prefs.remove('userId');
    await _prefs.remove('username');
    await _prefs.remove('userEmail');
  }
}
