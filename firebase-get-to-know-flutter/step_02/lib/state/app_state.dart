import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  bool _loggedIn = false;
  get loggedIn => _loggedIn;

  ApplicationState() {
    init();
  }
}

Future<void> init() async {}
