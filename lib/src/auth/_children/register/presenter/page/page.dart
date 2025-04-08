import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/src/auth/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              // Send to the Home Page (temporary)
              // See line 52 of login/presenter/page/page.dart
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const HomePage()),
              // );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (state is RegisterLoading)
                //   const Center(child: CircularProgressIndicator())
                // else
                //   // TODO: Implement RegisterForm with onRegister callback
              ],
            );
          },
        ),
      ),
    );
  }
}
