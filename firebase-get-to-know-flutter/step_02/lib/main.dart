import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'state/app_state.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ChangeNotifier appStateCallback(BuildContext context) => ApplicationState();
  Widget appCallback(BuildContext context, Widget? child) => const App();
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, child) => const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  build(BuildContext context) {
    return MaterialApp.router(
      title: 'Firebase Meetup',
      // navigatorKey: navigatorKey,
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.deepPurple,
            ),
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // home: const HomePage(),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(routes: <RouteBase>[
  GoRoute(path: '/', builder: _homePageCallback, routes: [
    GoRoute(path: 'sign-in', builder: _signInScreenCallback, routes: [
      GoRoute(path: 'forgot-password', builder: _forgotPasswordCallback)
    ]),
    GoRoute(path: 'profile', builder: _profileCallback)
  ]),
]);

Widget _homePageCallback(BuildContext context, GoRouterState? state) =>
    const HomePage();

Widget _signInScreenCallback(BuildContext context, GoRouterState state) =>
    SignInScreen(
      actions: [
        ForgotPasswordAction((context, email) {
          final uri = Uri(
            path: '/sign-in/forgot-password',
            queryParameters: <String, String?>{
              'email': email,
            },
          );
          context.push(uri.toString());
        }),
        AuthStateChangeAction(_authStateCallback)
      ],
    );

Widget _forgotPasswordCallback(BuildContext context, GoRouterState state) {
  final arugments = state.queryParams;
  return ForgotPasswordScreen(
    email: arugments['email'],
    headerMaxExtent: 200,
  );
}

Widget _profileCallback(BuildContext context, GoRouterState state) =>
    ProfileScreen(
      providers: const [],
      actions: [
        SignedOutAction((context) {
          context.pushReplacement('/');
        })
      ],
    );

void _authStateCallback(BuildContext context, AuthState state) {
  if (state is SignedIn || state is UserCreated) {
    var user = (state is SignedIn)
        ? state.user
        : (state as UserCreated).credential.user;
    if (user == null) {
      return;
    }
    if (state is UserCreated) {
      user.updateDisplayName(user.email!.split('@')[0]);
    }
    if (!user.emailVerified) {
      user.sendEmailVerification();
      // Declare snack bar
      const snackBar = SnackBar(
          content:
              Text('Please check your email to verify your email address.'));
      // Call snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    context.pushReplacement('/');
  }
}
