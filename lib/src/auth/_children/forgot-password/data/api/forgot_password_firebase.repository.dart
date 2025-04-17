import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
