abstract class ForgotPasswordRepository {
  Future<void> sendResetEmail(String email);
}
