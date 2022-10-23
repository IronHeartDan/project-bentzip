import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String? label;
  final void Function()? onTap;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool? obscureText;

  const FormInput({Key? key, this.label, this.onTap, this.validator, this.textEditingController, this.textInputType, this.textInputAction, this.onSaved,  this.obscureText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      obscureText: obscureText ?? false,
      validator: validator,
      onSaved: onSaved,
      onTap: onTap,
      controller: textEditingController,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          label: label != null ? Text(label!) : const Text(""),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)))),
    );
  }
}
