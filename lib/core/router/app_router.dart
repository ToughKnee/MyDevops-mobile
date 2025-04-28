import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/src/auth/auth.dart';
import 'app_routes.dart';
import 'paths.dart';
import 'router_utils.dart';

GoRouter createRouter(BuildContext context) {
  final loginBloc = context.read<LoginBloc>();
  final notifier = context.read<RouterRefreshNotifier>();

  return GoRouter(
    initialLocation: Paths.login,
    refreshListenable: notifier,
    redirect: (context, state) {
      final loginState = loginBloc.state;
      final isOnLogin = state.uri.toString() == Paths.login;
      final isAuthenticated = loginState is LoginSuccess;

      if (!isAuthenticated && !isOnLogin) {
        return Paths.login;
      } else if (isAuthenticated && isOnLogin) {
        return Paths.home;
      }
      return null;
    },
    routes: appRoutes,
  );
}

