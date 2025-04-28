abstract class ForgotPasswordRepository {
  Future<String> sendResetEmail(String email);
}
