import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:mobile/src/auth/auth.dart';

class LoginRepositoryFirebase implements LoginRepository {
  final firebase.FirebaseAuth _firebaseAuth;

  LoginRepositoryFirebase({firebase.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance;

  @override
  Future<AuthUserInfo> login(String username, String password) async {
    try {
      final userData = await _firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      final firebaseUser = userData.user;

      final firebaseIdToken = await firebaseUser!.getIdToken();
      if (firebaseIdToken == null) {
        throw AuthException('Failed authentication');
      }

      return AuthUserInfo(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        authProviderToken: firebaseIdToken,
      );
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
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
