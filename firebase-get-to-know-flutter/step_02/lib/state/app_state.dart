// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import '../constant/models/guest_book_message.dart';
import '../firebase_options.dart';
import 'dart:ui';

// TODO: NOTES ON: Listener Callback | Listener callbacks must end by notifying the listeners??

// TODO: Review working with ChangeNotifier and Listeners

// TODO: Review: Subscribing to streams, unsubscribing to streams and listening to streaming data

// TODO: Understand Provider package more and how state is distributed throughout your application

// TODO: What does it mean to have a subscribed a query? | is subscribing to a stream querying a stream | What are diffrent query subscription types?

enum Attending { yes, no, unknown }

class ApplicationState extends ChangeNotifier {
  bool _loggedIn = false;
  int _attendees = 0;
  Attending _attending = Attending.unknown;
  List<GuestBookMessage> _guestBookMessages = [];
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;

  int get attendees => _attendees;
  Attending get attending => _attending;
  bool get loggedIn => _loggedIn;
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  set attending(Attending attending) {
    final collection = FirebaseFirestore.instance.collection('attendees');
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = collection.doc(userId);
    if (attending == Attending.yes) {
      userDoc.set(<String, Object>{'attending': true});
    } else {
      userDoc.set(<String, Object>{'attending': false});
    }
  }

  ApplicationState() {
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseFirestore.instance
        .collection('attendees')
        .where('attending', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      _attendees = snapshot.docs.length;
    });

    FirebaseAuth.instance.userChanges().listen(_getMessagesListenerCallback);
  }

  void addMessageToGuestBook(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in.');
    } else {
      final CollectionReference colRef =
          FirebaseFirestore.instance.collection('guestbook');
      final User user = FirebaseAuth.instance.currentUser as User;
      final String textID = colRef.doc().id;
      final Map<String, Object> textObject = GuestBookMessage(
              textID: textID,
              userID: user.uid,
              name: user.displayName as String,
              message: message)
          .toJSON();

      colRef.doc(textID).set(textObject);
    }
  }

// Subscribe to firebase firestore StreamSubscriptions (Adding listeners to snapshots)
  void _getMessagesListenerCallback(User? user) {
    user != null ? _loggedIn = true : _loggedIn = false;

    if (user != null) {
      _loggedIn = true;

      _guestBookSubscription = FirebaseFirestore.instance
          .collection('guestbook')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen(_guestBookListenerCallback);

      _attendingSubscription = FirebaseFirestore.instance
          .collection('attendees')
          .doc(user.uid)
          .snapshots()
          .listen(_attendingListenerCallback);
    } else {
      _loggedIn = false;
      _guestBookMessages = [];
      _guestBookSubscription?.cancel();
      _attendingSubscription?.cancel();
    }

    notifyListeners();
  }

  void _guestBookListenerCallback(QuerySnapshot<Map> snapshot) {
    _guestBookMessages = [];
    for (final document in snapshot.docs) {
      _guestBookMessages.add(
        GuestBookMessage(
            textID: document.data()['textID'] as String,
            userID: document.data()['userid'] as String,
            name: document.data()['name'] as String,
            message: document.data()['text'] as String),
      );
    }
    notifyListeners();
  }

  void _attendingListenerCallback(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.data() != null) {
      if (snapshot.data()!['attending'] as bool) {
        _attending = Attending.yes;
      } else {
        _attending = Attending.no;
      }
    } else {
      _attending = Attending.unknown;
    }
    notifyListeners();
  }
}
