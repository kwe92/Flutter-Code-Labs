import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import 'yes_no_buttons.dart';

typedef VoidCallback = void Function(Attending selection);

class YesNoSection extends StatelessWidget {
  final Attending state;
  final VoidCallback onSelection;
  const YesNoSection(
      {required this.state, required this.onSelection, super.key});

  @override
  Widget build(BuildContext context) {
    final buttons = YesNoButtons(onSelection: onSelection);

    final Padding yes = Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: buttons.yesButtons()),
    );
    final Padding no = Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: buttons.noButtons()),
    );

    final Padding def = Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: buttons.defaultButtons()),
    );

    switch (state) {
      case Attending.yes:
        return yes;
      case Attending.no:
        return no;
      default:
        return def;
    }
  }
}



// Enumerations work well with switch statements and can auto complete the switch body
// Switch will throw a warning if there is no default specificed and all enumeration items are not conditionally defined within the switch body

// Type Alias
//    - similar to using the [type] keyword in TypeScript to shorten type names and given them an Allias
//    - Functions are objects and can have a type??
