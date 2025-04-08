import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/src/auth/auth.dart';

class UserSessionStorage {
  static const String _userKey = 'user_data';

  static Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final userData = jsonEncode({
        'id': user.id,
        'username': user.username,
        'email': user.email,
      });

      return await prefs.setString(_userKey, userData);
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final userData = prefs.getString(_userKey);

    if (userData == null) {
      return null;
    }

    try {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return User(
        id: userMap['id'],
        username: userMap['username'],
        email: userMap['email'],
      );
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final user = await getUser();
      return user != null;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  static Future<bool> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_userKey);
  }
}
