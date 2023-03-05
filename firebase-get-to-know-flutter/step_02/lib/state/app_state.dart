import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;

  ApplicationState() {
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      user != null ? _loggedIn = true : _loggedIn = false;

      notifyListeners();
    });
  }

  Future? addMessageToGuestBook(String message) => !_loggedIn
      ? throw Exception('Must be logged in.')
      : FirebaseFirestore.instance.collection('guestbook').add(<String, Object>{
          'text': message,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'name': FirebaseAuth.instance.currentUser!.displayName as Object,
          'userid': FirebaseAuth.instance.currentUser!.displayName as Object,
        });
}
