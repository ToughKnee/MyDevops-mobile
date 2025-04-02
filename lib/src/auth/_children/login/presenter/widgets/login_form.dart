import 'package:flutter/material.dart';
import 'package:mobile/src/auth/auth.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String) onLogin;

  const LoginForm({super.key, required this.onLogin});
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmailField(),
          _buildPasswordField(),
          SizedBox(height: 20),
          _buildLoginButton(),
        ],
      ),
    );
  }

  // Method to build the email input field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: 'Email'),
      validator: UserValidator.validateEmail,
    );
  }

  // Method to build the password input field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: UserValidator.validatePass,
    );
  }

  // Method to build the login button
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget.onLogin(_emailController.text, _passwordController.text);
        }
      },
      child: Text('Login'),
    );
  }
}
