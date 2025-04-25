import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/src/auth/auth.dart';
import 'package:mobile/core/globals/widgets/primary_button.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.read<LoginBloc>().add(LoginReset());
        } else if (state is LogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<LogoutBloc, LogoutState>(
        builder: (context, state) {
          final isLoading = state is LogoutLoading;

          return PrimaryButton(
            text: 'Log Out',
            isLoading: isLoading,
            isEnabled: !isLoading,
            onPressed: () {
              context.read<LogoutBloc>().add(LogoutRequested());
            },
          );
        },
      ),
    );
  }
}