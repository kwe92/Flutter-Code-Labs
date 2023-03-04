import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class GuestBook extends StatefulWidget {
  final FutureOr<void> Function(String message) addMessage;

  const GuestBook({required this.addMessage, super.key});

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: 'Leave a message'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your message to continue.';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              StyledButton(
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('SEND'),
                    ],
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text);
                      // Clear input text
                      _controller.clear();
                    }
                  })
            ],
          )),
    );
  }
}
