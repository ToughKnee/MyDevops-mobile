import 'package:ez_validator/ez_validator.dart';

class UserValidator {
  static String? validateEmail(String? value) {
    return EzValidator<String>().required().validate(value);
    // TODO: ADD .email() to the validator when the api is ready
    // TODO: Uncomment the following lines when the api is ready
    // if (validator != null) return validator;
    // if (value != null && !value.endsWith('@ucr.ac.cr')) {
    //   return "Email must end with @ucr.ac.cr";
    // }
    // return null;
  }

  static String? validatePass(String? value) {
    return EzValidator<String>().required().minLength(8).validate(value);
  }
}
