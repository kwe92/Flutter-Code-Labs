import 'package:flutter/material.dart';
import 'constant/router/app-router.dart';
import 'constant/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  build(BuildContext context) {
    return MaterialApp.router(
      title: 'Firebase Meetup',
      theme: AppTheme.theme(context),
      routerConfig: AppRouter.router,
    );
  }
}
