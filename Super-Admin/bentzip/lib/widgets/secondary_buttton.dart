import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SecondaryButton extends StatefulWidget {
  final void Function() onPress;
  final String text;

  const SecondaryButton({Key? key, required this.text, required this.onPress})
      : super(key: key);

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        clipBehavior: Clip.hardEdge,
        style: ElevatedButton.styleFrom(
            foregroundColor: primaryColor,
            backgroundColor: secondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 43),
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(40)))),
        onPressed: widget.onPress,
        child: Text(widget.text));
  }
}
