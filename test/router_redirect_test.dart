import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/router/app_router.dart';

void main() {
  String? go(String location, {bool loading = false, bool loggedIn = false}) =>
      authRedirect(location: location, authLoading: loading, loggedIn: loggedIn);

  test('splash and onboarding are never redirected', () {
    for (final loggedIn in [true, false]) {
      expect(go('/splash', loggedIn: loggedIn), isNull);
      expect(go('/onboarding', loggedIn: loggedIn), isNull);
    }
  });

  test('nothing moves while the session is still loading', () {
    expect(go('/home', loading: true), isNull);
  });

  test('signed-out users only reach the login and sign-up pages', () {
    expect(go('/home'), '/login');
    expect(go('/khetma/abc'), '/login');
    expect(go('/reset-password'), '/login');
    expect(go('/login'), isNull);
    expect(go('/register'), isNull);
  });

  test('signed-in users skip the auth pages but reach everything else', () {
    expect(go('/login', loggedIn: true), '/home');
    expect(go('/register', loggedIn: true), '/home');
    expect(go('/home', loggedIn: true), isNull);
    expect(go('/reset-password', loggedIn: true), isNull);
  });
}
