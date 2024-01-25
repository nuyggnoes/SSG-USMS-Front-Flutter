import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  const CustomToggleButton({super.key, required this.buttonText});
  final buttonText;

  @override
  State<CustomToggleButton> createState() => _ToggleButtonState();
}

Map<String, bool> filterButtonStates = {
  '입실': false,
  '퇴실': false,
  '폭행, 싸움': false,
  '절도, 강도': false,
  '기물 파손': false,
  '실신': false,
  '투기': false,
  '주취행동': false,
};

class _ToggleButtonState extends State<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterButtonStates[widget.buttonText] =
              !filterButtonStates[widget.buttonText]!;
          print(
              '${widget.buttonText} 의 상태 : ${filterButtonStates[widget.buttonText]}');
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(40),
          color: filterButtonStates[widget.buttonText]!
              ? Colors.blue
              : Colors.white,
        ),
        child: Text(
          '#${widget.buttonText}',
          style: TextStyle(
            color: filterButtonStates[widget.buttonText]!
                ? Colors.white
                : Colors.blue,
          ),
        ),
      ),
    );
  }
}
