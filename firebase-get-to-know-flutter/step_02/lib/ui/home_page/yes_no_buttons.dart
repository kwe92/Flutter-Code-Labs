import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../widgets/widgets.dart';

typedef VoidCallback = void Function(Attending attending);

class YesNoButtons {
  final VoidCallback onSelection;
  final Text _yesText = const Text('yes');
  final Text _noText = const Text('no');
  final _sizedBox = const SizedBox(width: 8);

  const YesNoButtons({required this.onSelection});

  List<Widget> defaultButtons() => <Widget>[
        StyledButton(
          onPressed: () => onSelection(Attending.yes),
          child: _yesText,
        ),
        _sizedBox,
        StyledButton(
          onPressed: () => onSelection(Attending.no),
          child: _noText,
        )
      ];

  List<Widget> noButtons() => <Widget>[
        TextButton(
            onPressed: () => onSelection(Attending.yes), child: _yesText),
        _sizedBox,
        _CustomElevatedButton(_noText, onSelection, Attending.no)
      ];

  List<Widget> yesButtons() => <Widget>[
        _CustomElevatedButton(_yesText, onSelection, Attending.yes),
        _sizedBox,
        TextButton(
          onPressed: () => onSelection(Attending.no),
          child: _noText,
        ),
      ];
}

class _CustomElevatedButton extends StatelessWidget {
  final double? elevation = 3;
  final Text text;
  final VoidCallback onSelection;
  final Attending attending;
  const _CustomElevatedButton(this.text, this.onSelection, this.attending,
      {super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(elevation: elevation),
        onPressed: () => onSelection(Attending.yes),
        child: text,
      );
}
