import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/router/router_utils.dart';
import 'package:mobile/core/router/paths.dart';

void main() {
  group('getIndexFromLocation', () {
    test('returns correct index for search path', () {
      expect(getIndexFromLocation(Paths.search), 1);
    });

    test('returns correct index for create path', () {
      expect(getIndexFromLocation(Paths.create), 2);
    });

    test('returns correct index for notifications path', () {
      expect(getIndexFromLocation(Paths.notifications), 3);
    });

    test('returns correct index for profile path', () {
      expect(getIndexFromLocation(Paths.profile), 4);
    });

    test('returns 0 for unknown paths', () {
      expect(getIndexFromLocation('/unknown'), 0);
      expect(getIndexFromLocation(Paths.home), 0);
      expect(getIndexFromLocation(Paths.login), 0);
    });
  });

  test('RouterRefreshNotifier notifies listeners on refresh', () {
    final notifier = RouterRefreshNotifier();

    var called = false;
    notifier.addListener(() {
      called = true;
    });

    notifier.refresh();
    expect(called, isTrue);
  });
}
