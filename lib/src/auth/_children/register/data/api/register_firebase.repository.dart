import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:mobile/src/auth/auth.dart';

class RegisterRepositoryFirebase implements RegisterRepository {
  final firebase.FirebaseAuth _firebaseAuth;

  RegisterRepositoryFirebase({firebase.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  @override
  Future<User> register(String username, String password) async {
    try {
      final userData = await _firebaseAuth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );

      final firebaseUser = userData.user;

      if (firebaseUser == null) {
        throw AuthException('Unexpected error: user is null after creation.');
      }

      await firebaseUser.sendEmailVerification();
      
      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        username: firebaseUser.displayName ?? username,
      );
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException('Email already in use');
        case 'invalid-email':
          throw AuthException('Invalid email format');
        case 'operation-not-allowed':
          throw AuthException('Operation not allowed');
        case 'weak-password':
          throw AuthException('Weak password');
        default:
          throw AuthException('Failed to register, error: ${e.code}');
      }
    } catch (e) {
      throw AuthException('Unexpected error: $e');
    }

  }
}