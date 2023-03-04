import 'package:go_router/go_router.dart';
import '../callbacks/callbacks.dart';

class AppRouter {
  static final router = GoRouter(routes: <RouteBase>[
    GoRoute(path: '/', builder: GoRouterCallbacks.homePageCallback, routes: [
      GoRoute(
          path: 'sign-in',
          builder: GoRouterCallbacks.signInScreenCallback,
          routes: [
            GoRoute(
                path: 'forgot-password',
                builder: GoRouterCallbacks.forgotPasswordCallback)
          ]),
      GoRoute(path: 'profile', builder: GoRouterCallbacks.profileCallback)
    ]),
  ]);
}
