import 'package:flutter/material.dart';
import 'package:usms_app/widget/custom_keyboard.dart';

class SecondaryPasswordScreen extends StatefulWidget {
  const SecondaryPasswordScreen({super.key});
  static const route = '/secondary-password';

  @override
  State<SecondaryPasswordScreen> createState() =>
      _SecondaryPasswordScreenState();
}

class _SecondaryPasswordScreenState extends State<SecondaryPasswordScreen> {
  String secondaryPassword = '';

  final List<bool> _filledCircles = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [' ', '0', const Icon(Icons.keyboard_backspace)],
  ];

  @override
  void initState() {
    super.initState();
    secondaryPassword = '';
  }

  onConfirmClicked() {
    print('ConfirmButton Clicked');
    print('2차 비밀번호는 $secondaryPassword');
  }

  onNumberPress(val) {
    setState(() {
      if (secondaryPassword.length < 6) {
        secondaryPassword = secondaryPassword + val;
      }
    });
  }

  onBackspacePress(val) {
    setState(() {
      secondaryPassword =
          secondaryPassword.substring(0, secondaryPassword.length - 1);
    });
  }

  renderKeyboard() {
    return keys
        .map(
          (x) => Row(
            children: x.map((y) {
              return Expanded(
                child: KeyboardKey(
                  label: y,
                  onTap: (y) {
                    y is Widget ? onBackspacePress(y) : onNumberPress(y);
                    _updateFilledCircles(secondaryPassword.length);
                  },
                  value: y,
                ),
              );
            }).toList(),
          ),
        )
        .toList();
  }

  Widget _buildPasswordCircle(bool filled) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? Colors.black : Colors.transparent,
        border: Border.all(color: Colors.black),
      ),
    );
  }

  void _updateFilledCircles(int length) {
    setState(() {
      for (int i = 0; i < _filledCircles.length; i++) {
        _filledCircles[i] = i < length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2차 비밀번호 입력'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < _filledCircles.length; i++)
                    _buildPasswordCircle(_filledCircles[i]),
                ],
              ),
            ),
            ...renderKeyboard(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    secondaryPassword.length == 6 ? onConfirmClicked : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryPassword.length == 6
                      ? Colors.blueAccent
                      : Colors.grey,
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
