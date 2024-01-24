import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerButton extends StatefulWidget {
  const DatePickerButton({super.key, required this.date});

  final DateTime? date;
  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        side: const MaterialStatePropertyAll(
          BorderSide(color: Colors.grey),
        ),
        fixedSize: MaterialStateProperty.all(
          const Size(80, 50),
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          locale: const Locale('ko', 'KR'),
        );
        if (selectedDate != null) {
          setState(() {
            date = selectedDate;
          });
        }
      },
      child: Text(
        date == null ? '' : DateFormat('yyyy-MM-dd').format(date!),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
