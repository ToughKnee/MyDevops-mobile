import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_validator/ez_validator.dart';

// Authentication state management using Bloc
class AuthCubit extends Cubit<bool> {
  // Initial state is false (not authenticated)
  AuthCubit() : super(false);

  // Method to validate login credentials
  void login(String email, String password) {
    emit(email == "admin@ucr.ac.cr" && password == "password123");
  }
}


// Login screen widget
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmailField(), // Email input field
              _buildPasswordField(), // Password input field
              SizedBox(height: 20),
              _buildLoginButton(context), // Login button
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the email input field
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        final validator = EzValidator<String>()
            .required()
            .email()
            .validate(value);
        // Validates if the email ends with @ucr.ac.cr
        if (validator != null) return validator;
        if (!value!.endsWith("@ucr.ac.cr")) {
          return "Email must end with @ucr.ac.cr";
        }
        return null;
      },
    );
  }

  // Method to build the password input field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(labelText: 'Password'),
      validator: (value) => EzValidator<String>().required().minLength(8).validate(value),
    );
  }

  // Method to build the login button
  Widget _buildLoginButton(BuildContext context) {
    return BlocConsumer<AuthCubit, bool>(
      listener: (context, isAuthenticated) {
        if (isAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid credentials')),
          );
        }
      },
      builder: (context, isAuthenticated) {
        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthCubit>().login(
                _emailController.text,
                _passwordController.text,
              );
            }
          },
          child: Text('Login'),
        );
      },
    );
  }
}

// Home screen displayed after successful login
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Welcome!')),
    );
  }
}

