import 'package:flutter/material.dart';

class MyCheckBox extends StatefulWidget {
  final String checkboxText;
  const MyCheckBox({
    super.key,
    required this.checkboxText,
  });

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();

  bool get isChecked => _MyCheckBoxState()._isChecked;
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
              });
              print('체크 상태(true면 체크상태) : $_isChecked');
            },
          ),
        ),
        Text(
          widget.checkboxText,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
