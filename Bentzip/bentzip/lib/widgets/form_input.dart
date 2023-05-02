import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInput extends StatelessWidget {
  final String? label;
  final void Function()? onTap;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final bool readOnly;

  const FormInput(
      {Key? key,
        this.label,
        this.onTap,
        this.validator,
        this.textEditingController,
        this.textInputType,
        this.textInputAction,
        this.textCapitalization = TextCapitalization.characters,
        this.onSaved,
        this.maxLines,
        this.inputFormatters,
        this.suffixIcon,
        this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      onTap: onTap,
      inputFormatters: inputFormatters,
      controller: textEditingController,
      textInputAction: textInputAction,
      readOnly: readOnly,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          label: label != null ? Text(label!) : const Text(""),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)))),
    );
  }
}
