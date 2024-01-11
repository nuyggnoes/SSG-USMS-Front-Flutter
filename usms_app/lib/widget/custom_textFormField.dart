import 'package:flutter/material.dart';

class VertificationTextField extends StatefulWidget {
  final hintText;
  final TextInputType textInputType;

  const VertificationTextField({
    super.key,
    required this.hintText,
    required this.textInputType,
  });

  @override
  State<VertificationTextField> createState() => _CertificationTextFieldState();
}

class _CertificationTextFieldState extends State<VertificationTextField> {
  bool isVerificationVisible = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: widget.textInputType,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              labelText: '${widget.hintText}',
              helperText: '',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              print('인증번호받기');
              isVerificationVisible = true;
            });
          },
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(130, 44)),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          child: Text(
            '인증번호 받기',
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
