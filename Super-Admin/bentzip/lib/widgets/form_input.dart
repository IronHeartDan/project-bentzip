import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String? label;
  void Function()? onTap;

  FormInput({Key? key, this.label,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      decoration: InputDecoration(
          label: label != null ? Text(label!) : const Text(""),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)))),
    );
  }
}
