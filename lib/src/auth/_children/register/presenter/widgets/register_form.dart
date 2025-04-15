import 'package:flutter/material.dart';
import 'package:mobile/src/auth/auth.dart';

class RegisterForm extends StatefulWidget {
  final Function(String, String, String) onRegister;

  const RegisterForm({super.key, required this.onRegister});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNameField(),
          const SizedBox(height: 20),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildConfirmPasswordField(),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            child: _buildRegisterButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Name',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: UserValidator.validateName,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: UserValidator.validateEmail,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Colors.white,
          filled: true,
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
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: _confirmPasswordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRegisterButton() {
    return PrimaryButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          widget.onRegister(_nameController.text, _emailController.text, _passwordController.text);
        }
      },
      isLoading: false,
      text: 'Register',
    );
  }
}