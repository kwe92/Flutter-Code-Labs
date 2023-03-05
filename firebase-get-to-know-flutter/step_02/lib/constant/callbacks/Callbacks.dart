import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/home_page.dart';

class GoRouterCallbacks {
  const GoRouterCallbacks();
  static Widget homePageCallback(BuildContext context, GoRouterState? state) =>
      const HomePage();

  static Widget signInScreenCallback(
          BuildContext context, GoRouterState state) =>
      _customScaffold(
          child: SignInScreen(
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
          AuthStateChangeAction(authStateCallback)
        ],
      ));

  static Widget forgotPasswordCallback(
      BuildContext context, GoRouterState state) {
    final arugments = state.queryParams;
    return _customScaffold(
        child: ForgotPasswordScreen(
      email: arugments['email'],
      headerMaxExtent: 200,
    ));
  }

  static Widget profileCallback(BuildContext context, GoRouterState state) =>
      _customScaffold(
          child: ProfileScreen(
        providers: const [],
        actions: [
          SignedOutAction((context) {
            context.pushReplacement('/');
          })
        ],
      ));

  static void authStateCallback(BuildContext context, AuthState state) {
    if (state is SignedIn || state is UserCreated) {
      final user = (state is SignedIn)
          ? state.user
          : (state as UserCreated).credential.user;
      if (user == null) {
        return;
      }
      if (state is UserCreated) {
        user.updateDisplayName(user.email!.split('@')[0]);
      }
      if (!user.emailVerified) {
        const content =
            Text('Please check your email to verify your email address.');

        user.sendEmailVerification();
        // Declare snack bar
        const snackBar = SnackBar(content: content);
        // Call snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      context.pushReplacement('/');
    }
  }
}

Widget _customScaffold(
        {required Widget child, Widget title = const Text('Firebase Demo')}) =>
    Scaffold(
        appBar: AppBar(
          title: title,
        ),
        body: child);
