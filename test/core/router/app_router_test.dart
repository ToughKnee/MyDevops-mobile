import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/router/app_routes.dart';
import 'package:mobile/core/router/paths.dart';
import 'package:mobile/core/router/router_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/src/auth/auth.dart';
import 'package:mobile/src/auth/_children/login/presenter/presenter.dart';
import 'package:mobile/src/home/presenter/presenter.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

class MockRouterRefreshNotifier extends Mock implements RouterRefreshNotifier {}

class FakeUser implements AuthUserInfo {
  final String _username;
  final String _password;

  FakeUser({required String username, required String password})
      : _username = username,
        _password = password;

  @override
  String get username => _username;

  @override
  String get password => _password;

  @override
  String get authProviderToken => "fakeToken";

  @override
  String get email => "fakeemail@example.com";

  @override
  String get id => "fakeId";

  @override
  String? get name => "Fake User";
}

void main() {
  late MockLoginBloc mockLoginBloc;
  late MockRouterRefreshNotifier mockNotifier;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    mockNotifier = MockRouterRefreshNotifier();
    when(() => mockLoginBloc.stream).thenAnswer((_) => Stream.value(LoginInitial()));
    when(() => mockLoginBloc.state).thenReturn(LoginInitial());
  });

  Widget createTestApp(GoRouter router) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>.value(value: mockLoginBloc),
        ListenableProvider<RouterRefreshNotifier>.value(value: mockNotifier),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  GoRouter createTestRouter() {
    return GoRouter(
      initialLocation: Paths.login,
      routes: appRoutes,
      redirect: (context, state) {
        final loginState = mockLoginBloc.state;
        final isLogin = state.uri.path == Paths.login;

        if (loginState is LoginSuccess) {
          return isLogin ? Paths.home : null;
        } else {
          return isLogin ? null : Paths.login;
        }
      },
      refreshListenable: mockNotifier,
    );
  }

  group('AppRouter Tests', () {
    testWidgets('redirects to login if not authenticated', (tester) async {
      when(() => mockLoginBloc.state).thenReturn(LoginInitial());

      final router = createTestRouter();
      await tester.pumpWidget(createTestApp(router));
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, Paths.login);
    });

    testWidgets('redirects to home if authenticated and on login page', (tester) async {
      when(() => mockLoginBloc.state).thenReturn(LoginSuccess(user: FakeUser(username: "test", password: "password")));

      final router = createTestRouter();
      await tester.pumpWidget(createTestApp(router));
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, Paths.home);
    });

    testWidgets('stays on desired page if already authenticated', (tester) async {
      when(() => mockLoginBloc.state).thenReturn(LoginSuccess(user: FakeUser(username: "test", password: "password")));

      final router = createTestRouter();
      await tester.pumpWidget(createTestApp(router));
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.last.matchedLocation, Paths.home);
    });
  });
}
