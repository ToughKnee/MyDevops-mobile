import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../forgot_password.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    final regex = RegExp(r'^[\w-\.]+@ucr\.ac\.cr$');

    if (email.isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (!regex.hasMatch(email)) {
      return 'Correo inválido. Debe ser del dominio @ucr.ac.cr';
    }

    return null;
  }

  void _showDialog(String title, String message, {bool success = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        // Cierra automático en 5 segundos
        Future.delayed(const Duration(seconds: 5), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
            if (success) {
              Navigator.of(context).pop(); // Regresa al login
            }
          }
        });

        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (success) {
                  Navigator.of(context).pop(); // Regresa al login
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onSubmit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final email = _emailController.text.trim();
      context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted(email));
    } else {
      _emailController.clear(); // Limpiar el campo si el correo es inválido
      _showDialog(
        'Correo inválido',
        'Por favor ingrese un correo válido del dominio @ucr.ac.cr',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          _showDialog(
            'Correo enviado',
            'Correo de recuperación enviado correctamente.',
            success: true, // activamos el regreso automático
          );
        } else if (state is ForgotPasswordFailure) {
          _showDialog('Error', state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
