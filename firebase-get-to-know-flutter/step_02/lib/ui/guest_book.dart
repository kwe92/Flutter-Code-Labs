import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constant/models/guest_book_message.dart';
import '../widgets/widgets.dart';

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
        Padding(
          padding: const EdgeInsets.all(8),
          child: _Form(
              formKey: _formKey,
              controller: _controller,
              addMessage: widget.addMessage),
        ),
        const SizedBox(height: 8),
        for (var message in widget.messages)
          GestureDetector(
            child: Paragraph('${message.name}: ${message.message}'),
            onLongPress: () {
              final FirebaseAuth auth = FirebaseAuth.instance;
              final User? user = auth.currentUser;
              final String? uid = user?.uid;
              if (uid == message.id) {
                print('the ids are the SAME!');
              }
              print('CURRENT USER: $uid');
              print('CURRENT USER: ${user?.displayName}');

              _bottomSheet(mainContext);
            },
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _Form extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController? controller;
  final Function addMessage;
  const _Form(
      {required this.formKey,
      required this.controller,
      required this.addMessage,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Row(
          children: [
            _expanded(controller),
            const SizedBox(width: 8),
            _button(
                formKey: formKey,
                controller: controller,
                addMessage: addMessage)
          ],
        ));
  }
}

Widget _expanded(TextEditingController? controller) => Expanded(
      child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Leave a message'),
          validator: (value) => value == null || value.isEmpty
              ? 'Enter your message to continue.'
              : null),
    );

Widget _button(
        {required GlobalKey<FormState>? formKey,
        required TextEditingController? controller,
        required Function addMessage}) =>
    StyledButton(
        child: Row(
          children: const <Widget>[
            Icon(Icons.send),
            SizedBox(width: 4),
            Text('SEND'),
          ],
        ),
        onPressed: () async {
          if (formKey!.currentState!.validate()) {
            await addMessage(controller!.text);
            // Clear input text
            controller.clear();
          }
        });

PersistentBottomSheetController _bottomSheet(BuildContext context) =>
    showBottomSheet(
      context: context,
      builder: (context) => SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: Text('Are you sure you want to delete the message?'),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(
                    'DELETE',
                    style: TextStyle(color: Colors.red.shade500),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Go Back'),
                )
              ],
            ),
          )),
    );
