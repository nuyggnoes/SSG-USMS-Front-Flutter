import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.textController,
    required this.textType,
    required this.validator,
    this.labelText,
    this.maxLength,
    this.focusNode,
    this.onChange,
    this.isEnabled,
    this.counterText,
    this.isObcureText,
  });

  final TextEditingController textController;
  final TextInputType textType;
  final String? Function(String?) validator;
  final String? labelText;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool? isEnabled;
  final String? counterText;
  final bool? isObcureText;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        enabled: isEnabled,
        obscureText: isObcureText ?? false,
        onChanged: onChange,
        focusNode: focusNode,
        maxLength: maxLength,
        controller: textController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          labelText: labelText,
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
          ),
          helperText: '',
          counterText: counterText,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
