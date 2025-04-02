import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/src/auth/auth.dart';

class AuthCubit extends Cubit<bool> {
  // Initial state is false (not authenticated)
  AuthCubit() : super(false);

  // Method to validate login credentials
  void login(String email, String password) {
    emit(email == "admin@ucr.ac.cr" && password == "password123");
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthCubit, bool>(
          listener: (context, isAuthenticated) {
            if (isAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Invalid credentials')));
            }
          },
          builder: (context, isAuthenticated) {
            return LoginForm(
              onLogin: (email, password) {
                context.read<AuthCubit>().login(email, password);
              },
            );
          },
        ),
      ),
    );
  }
}

// TODO: Redirect to the actual home screen of the app
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Welcome!')),
    );
  }
}
