import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/src/auth/auth.dart';

void main() {
  group('UserValidator Schema - Validate email', () {
    test('should return error when email is empty', () {
      final result = UserValidator.validateEmail('');
      expect(result, 'This field is required');
    });

    test('should return error when email is null', () {
      final result = UserValidator.validateEmail(null);
      expect(result, 'This field is required');
    });

    test('should return error when email is invalid', () {
      final result = UserValidator.validateEmail('invalid-email');
      expect(result, 'Invalid email format');
    });

    test('should return error when the email does not end in @ucr.ac.cr', () {
      final result = UserValidator.validateEmail('user@gmail.com');
      expect(result, 'The email must end with @ucr.ac.cr');
    });

    test('should return null when the email is valid', () {
      final result = UserValidator.validateEmail('user@ucr.ac.cr');
      expect(result, null);
    });
  });

  group('UserValidator Schema - Validate password', () {
    test('should return error when password is empty', () {
      final result = UserValidator.validatePass('');
      expect(result, 'This field is required');
    });

    test('should return error when password is null', () {
      final result = UserValidator.validatePass(null);
      expect(result, 'This field is required');
    });

    test('should return error when password is too short', () {
      final result = UserValidator.validatePass('short');
      expect(result, 'The password must be at least 8 characters long');
    });

    test('should return error when password is too long', () {
      final result = UserValidator.validatePass('aB2' * 21);
      expect(result, 'The password must be at most 30 characters long');
    });

    test(
      'should return error when password does not contain uppercase letter',
      () {
        final result = UserValidator.validatePass('lowercase1');
        expect(
          result,
          'The password must contain at least one uppercase letter',
        );
      },
    );

    test(
      'should return error when password does not contain lowercase letter',
      () {
        final result = UserValidator.validatePass('UPPERCASE1');
        expect(
          result,
          'The password must contain at least one lowercase letter',
        );
      },
    );

    test('should return error when password does not contain number', () {
      final result = UserValidator.validatePass('NoNumber');
      expect(result, 'The password must contain at least one number');
    });

    test('should return null when password is valid', () {
      final result = UserValidator.validatePass('ValidPassword1');
      expect(result, null);
    });
  });
}
