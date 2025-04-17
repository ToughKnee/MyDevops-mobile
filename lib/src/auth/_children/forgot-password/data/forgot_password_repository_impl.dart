import '../forgot_password.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordApi api;

  ForgotPasswordRepositoryImpl(this.api);

  @override
  Future<void> sendResetEmail(String email) async {
    await api.sendPasswordResetEmail(email);
  }
}
