import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../forgot_password.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: BlocProvider(
        create: (_) => ForgotPasswordBloc(
          ForgotPasswordRepositoryImpl(ForgotPasswordApi()),
        ),
        child: const ForgotPasswordForm(),
      ),
    );
  }
}
