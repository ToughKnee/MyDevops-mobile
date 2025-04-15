import 'package:mobile/src/auth/auth.dart';

abstract class LoginRepository {
  Future<AuthUserInfo> login(String username, String password);
}
