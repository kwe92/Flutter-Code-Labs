import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';

// Type Alias
//    - similar to using the [type] keyword in TypeScript to shorten type names and given them an Allias
//    - Functions are objects and can have a type??

typedef VoidCallback = void Function(Attending selection);

class YesNoSection extends StatelessWidget {
  final Attending state;
  final VoidCallback onSelection;
  const YesNoSection(
      {required this.state, required this.onSelection, super.key});

  @override
  Widget build(BuildContext context) {
    // Enumerations work well with switch statements and can auto complete the switch body
    // Switch will throw a warning if there is no default specificed and all enumeration items are not conditionally defined within the sqitch body

    // TODO: Refactor for readablility
    switch (state) {
      case Attending.yes:
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      case Attending.no:
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: <Widget>[
            TextButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES')),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: () => onSelection(Attending.no),
              child: const Text('NO'),
            )
          ]),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              StyledButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(
                width: 8,
              ),
              StyledButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              )
            ],
          ),
        );
    }
  }
}
