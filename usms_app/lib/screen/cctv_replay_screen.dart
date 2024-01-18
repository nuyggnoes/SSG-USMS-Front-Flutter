import 'package:flutter/material.dart';

class CCTVReplay extends StatefulWidget {
  const CCTVReplay({super.key});

  @override
  State<CCTVReplay> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CCTVReplay> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CCTV 다시보기'),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime.now(),
            onDateChanged: (DateTime date) {
              setState(() {
                selectedDate = date;
              });
              // 다시보기 cctv 조회
            },
          ),
          Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Center(
              child: Text(
                '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
