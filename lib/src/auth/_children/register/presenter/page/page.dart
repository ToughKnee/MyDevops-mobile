import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/src/auth/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black, // Asegurate de que se vea bien según tu tema
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is RegisterLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  RegisterForm(
                    onRegister: (name, email, password) {
                      context.read<RegisterBloc>().add(
                            RegisterSubmitted(name: name, email: email, password: password),
                          );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}