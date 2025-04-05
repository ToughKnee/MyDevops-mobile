import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:mobile/src/auth/auth.dart';

class LoginRepositoryFirebase implements LoginRepository {
  final firebase.FirebaseAuth _firebaseAuth;

  LoginRepositoryFirebase({firebase.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  @override
  Future<User> login(String username, String password) async {
    try {
      final userData = await _firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      final firebaseUser = userData.user;

      if (firebaseUser == null) {
        throw AuthException('User not found');
      }

      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        username: firebaseUser.displayName ?? username,
      );
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
        //TODO handle remaining error codes
        case 'user-not-found':
          throw AuthException('User not found');
        case 'invalid-email':
          throw AuthException('Invalid email format');
        case 'invalid-credential':
          throw AuthException('Incorrect credentials');
        default:
          throw AuthException('failed, error: ${e.code}');
      }
    }
  }
}
