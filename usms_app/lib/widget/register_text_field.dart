import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    super.key,
    required this.labelText,
  });
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          helperText: '',
        ),
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return '$labelText을(를) 입력해주세요!';
          }
          return null;
        },
      ),
    );
  }
}
