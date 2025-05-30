import 'package:mobile/src/auth/auth.dart';

abstract class RegisterRepository {
  Future<AuthUserInfo> register(String name, String email, String password);
}
