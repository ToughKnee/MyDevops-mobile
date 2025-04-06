import 'package:mobile/src/auth/auth.dart';

abstract class RegisterRepository {
  Future<User> register(String username, String password);
}
