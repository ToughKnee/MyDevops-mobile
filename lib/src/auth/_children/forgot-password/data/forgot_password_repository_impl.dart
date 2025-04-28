import '../forgot_password.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordApi api;

  ForgotPasswordRepositoryImpl(this.api);

  @override
  Future<String> sendResetEmail(String email) {
    return api.sendPasswordResetEmail(email);
  }
}
