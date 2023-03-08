import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constant/models/guest_book_message.dart';
import '../../widgets/widgets.dart';
import 'custom_form.dart';

class GuestBook extends StatefulWidget {
  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages;

  const GuestBook(
      {required this.addMessage, required this.messages, super.key});

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext mainContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomForm(
            formKey: _formKey,
            controller: _controller,
            addMessage: widget.addMessage),
        const SizedBox(height: 8),
        for (var message in widget.messages)
          _gestureDetector(_Props2(context: context, message: message)),
        const SizedBox(height: 8),
      ],
    );
  }
}

Widget _gestureDetector(_Props2 props) => GestureDetector(
      child: Paragraph('${props.message.name}: ${props.message.message}'),
      onLongPress: () {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final User? user = auth.currentUser;
        final String? uid = user?.uid;
        if (uid == props.message.userID) {
          _bottomSheet(_Props1(
              context: props.context,
              path: 'guestbook',
              id: props.message.textID));
          // context: context, path: 'guestbook', id: message.textID
        }
      },
    );

PersistentBottomSheetController _bottomSheet(_Props1 props) => showBottomSheet(
      context: props.context,
      builder: (context) => SizedBox(
        height: 150,
        child: _bottomSheetContent(
            _Props1(context: context, path: props.path, id: props.id)),
      ),
    );

Widget _bottomSheetContent(_Props1 props) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Text('Are you sure you want to delete the message?'),
          ),
          _deleteButton(props),
          _backButton(props.context)
        ],
      ),
    );

Future<void> _deleteMessage({required _Props0 props}) async =>
    await FirebaseFirestore.instance
        .collection(props.path)
        .doc(props.id)
        .delete();

Widget _deleteButton(_Props1 props) => TextButton(
      onPressed: () {
        _deleteMessage(props: _Props0(path: props.path, id: props.id));
        props.context.pop();
      },
      child: Text(
        'DELETE',
        style: TextStyle(color: Colors.red.shade500),
      ),
    );

Widget _backButton(BuildContext context) => TextButton(
      onPressed: () {
        context.pop();
      },
      child: const Text('Go Back'),
    );

// Giving a functional component one argument
// Interfaces in Dart are implictly defined when you create and class and coupled with its implementation
// Therefore you can not in the Dart language create an Interface separate from its implementation

class _Props0 {
  final String path;
  final String id;
  const _Props0({required this.path, required this.id});
}

class _Props1 extends _Props0 {
  final BuildContext context;
  const _Props1(
      {required this.context, required super.path, required super.id});
}

class _Props2 {
  final BuildContext context;
  final GuestBookMessage message;

  const _Props2({
    required this.context,
    required this.message,
  });
}



 // Center(
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       const Padding(
        //         padding: EdgeInsets.only(top: 0.0),
        //         child: Text('Are you sure you want to delete the message?'),
        //       ),
        //       _deleteButton(context, path, id),
        //       _backButton(context)
        //     ],
        //   ),
        // ),

// Widget _bottomSheetContent(BuildContext context, String path, String id) =>
//     Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           const Padding(
//             padding: EdgeInsets.only(top: 0.0),
//             child: Text('Are you sure you want to delete the message?'),
//           ),
//           _deleteButton(context, path, id),
//           _backButton(context)
//         ],
//       ),
//     );



// Widget _deleteButton(BuildContext context, String path, String id) =>
//     TextButton(
//       onPressed: () {
//         _deleteMessage(path: path, id: id);
//         context.pop();
//       },
//       child: Text(
//         'DELETE',
//         style: TextStyle(color: Colors.red.shade500),
//       ),
//     );
