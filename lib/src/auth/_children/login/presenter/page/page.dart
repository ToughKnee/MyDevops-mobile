import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/core.dart';
import 'package:mobile/src/auth/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is LoginLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  LoginForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    onLogin: (email, password) {
                      context.read<LoginBloc>().add(
                            LoginSubmitted(
                              username: email,
                              password: password,
                            ),
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
// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocConsumer<LoginBloc, LoginState>(
//           listener: (context, state) {
//             if (state is LoginSuccess) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HomePage()),
//               );
//             } else if (state is LoginFailure) {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(SnackBar(content: Text(state.error)));
//             }
//           },
//           builder: (context, state) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (state is LoginLoading)
//                   const Center(child: CircularProgressIndicator())
//                 else
//                   LoginForm(
//                     onLogin: (username, password) {
//                       context.read<LoginBloc>().add(
//                         LoginSubmitted(username: username, password: password),
//                       );
//                     },
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// TODO: Redirect to the actual home screen of the app
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Welcome ${LocalStorage().userEmail}')),
    );
  }
}
