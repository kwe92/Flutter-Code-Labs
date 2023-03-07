// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import '../constant/models/guest_book_message.dart';
import '../firebase_options.dart';
import '../ui/guest_book.dart';

class ApplicationState extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;

  List<GuestBookMessage> _guestBookMessages = [];

  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  ApplicationState() {
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen(
      (user) {
        user != null ? _loggedIn = true : _loggedIn = false;

        if (user != null) {
          _loggedIn = true;
          _guestBookSubscription = FirebaseFirestore.instance
              .collection('guestbook')
              .orderBy('timestamp', descending: true)
              .snapshots()
              .listen((snapshot) {
            _guestBookMessages = [];
            for (final document in snapshot.docs) {
              _guestBookMessages.add(
                GuestBookMessage(
                    id: document.data()['userid'] as String,
                    name: document.data()['name'] as String,
                    message: document.data()['text'] as String),
              );
            }
            notifyListeners();
          });
        } else {
          _loggedIn = false;
          _guestBookMessages = [];
          _guestBookSubscription?.cancel();
        }

        notifyListeners();
      },
    );
  }

  Future? addMessageToGuestBook(String message) => !_loggedIn
      ? throw Exception('Must be logged in.')
      : FirebaseFirestore.instance.collection('guestbook').add(
          <String, Object>{
            'text': message,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'name': FirebaseAuth.instance.currentUser!.displayName as Object,
            'userid': FirebaseAuth.instance.currentUser!.uid,
          },
        );

  // TODO: Refactor?
  // Future? addMessageToGuestBook(String message) {
  //   if (!_loggedIn) {
  //     throw Exception('Must be logged in.');
  //   } else {
  //     FirebaseFirestore.instance.collection('guestbook').add();
  //   }
  // }
}

// <String, Object>{
//         'text': message,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'name': FirebaseAuth.instance.currentUser!.displayName as Object,
//         'userid': FirebaseAuth.instance.currentUser!.uid,
//       }
