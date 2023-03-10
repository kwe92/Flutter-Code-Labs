import '../../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' // new
    hide
        EmailAuthProvider,
        PhoneAuthProvider;
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../authentication/authentication.dart';
import '../guest_book/guest_book.dart';
import 'yes_no_section.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),
          Consumer<ApplicationState>(
            builder: _handleAuthCallback,
          ),
          const _CustomDivider(),
          const Header("What we'll be doing"),
          const Paragraph(
            'Join us for a day full of Firebase Workshops and Pizza!',
          ),
          Consumer<ApplicationState>(
            builder: _handleAddMessageCallback,
          ),
        ],
      );
}

Widget _handleAuthCallback(
        BuildContext context, ApplicationState appState, Widget? _) =>
    AuthFunc(
        loggedIn: appState.loggedIn,
        signOut: () {
          FirebaseAuth.instance.signOut();
        });

Widget _handleAddMessageCallback(
        BuildContext context, ApplicationState appState, Widget? _) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          // Dynamic Collections
          //   - Conditional Logic (At any element)
          //   - Destructuring + Conditional Logic

          [
        if (appState.attendees >= 2)
          Paragraph('${appState.attendees} people going.')
        else if (appState.attendees == 1)
          const Paragraph('1 person going.')
        else
          const Paragraph('no one going.'),
        if (appState.loggedIn) ...[
          YesNoSection(
              state: appState.attending,
              onSelection: (attending) => appState.attending = attending),
          const Header('Discussion'),
          GuestBook(
            addMessage: (message) => appState.addMessageToGuestBook(message),
            messages: appState.guestBookMessages,
          ),
        ],
      ],
    );

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) => const Divider(
        height: 8,
        thickness: 1,
        indent: 8,
        endIndent: 8,
        color: Colors.grey,
      );
}
