import 'package:mobile/src/auth/auth.dart';

abstract class LoginRepository {
  Future<User> login(String username, String password);
}
