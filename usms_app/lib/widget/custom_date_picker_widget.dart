import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:month_year_picker/month_year_picker.dart';

class MyCupertinoDatePicker extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDateChanged;

  const MyCupertinoDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showMonthYearPicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          locale: const Locale('ko', 'KR'),
        );
        if (selectedDate != null && onDateChanged != null) {
          onDateChanged!(selectedDate);
        }
      },
      child: AbsorbPointer(
        child: CupertinoTextField(
          controller: TextEditingController(
            text: "${initialDate.year}년 ${initialDate.month}월",
          ),
          readOnly: true,
          placeholder: 'Select Month and Year',
          textAlign: TextAlign.center,
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.inactiveGray),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
