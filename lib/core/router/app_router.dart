import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'paths.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Paths.home,
  /*
  refreshListenable: GoRouterRefreshStream(
    context.read<LoginBloc>().stream,
  ),
  redirect: (context, state) {
    final loginState = context.read<LoginBloc>().state;
    final isOnLogin = state.uri.toString() == Paths.login;
    final isAuthenticated = loginState is LoginSuccess;

    if (!isAuthenticated && !isOnLogin) {
      return Paths.login;
    } else if (isAuthenticated && isOnLogin) {
      return Paths.home;
    }
    return null;
  }*/
  routes: appRoutes,
);
