import 'package:flutter/material.dart';

import '../utils/constants.dart';

class PrimaryButton extends StatefulWidget {
  final void Function() onPress;
  final String text;
  final IconData? icon;

  const PrimaryButton(
      {Key? key, required this.text, required this.onPress, this.icon})
      : super(key: key);

  @override
  State<PrimaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        clipBehavior: Clip.hardEdge,
        style: ElevatedButton.styleFrom(
            foregroundColor: secondaryColor,
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 43),
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)))),
        onPressed: widget.onPress,
        child: widget.icon != null
            ? Row(
                children: [
                  const Icon(Icons.add),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.text)
                ],
              )
            : Text(widget.text));
  }
}
