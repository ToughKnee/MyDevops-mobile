import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_routes.dart';
import 'package:mobile/core/router/paths.dart';

void main() {
  test('appRoutes contains all expected paths', () {
    final paths = appRoutes.expand((r) {
      if (r is ShellRoute) {
        return r.routes.map((route) => (route as GoRoute).path);
      }
      return [(r as GoRoute).path];
    }).toList();

    expect(paths, containsAll([
      Paths.login,
      Paths.register,
      Paths.settings,
      Paths.home,
      Paths.search,
      Paths.create,
      Paths.notifications,
      Paths.profile,
    ]));
  });
}
