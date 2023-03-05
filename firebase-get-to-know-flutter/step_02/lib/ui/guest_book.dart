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
      child: _Form(
          formKey: _formKey,
          controller: _controller,
          addMessage: widget.addMessage),
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
