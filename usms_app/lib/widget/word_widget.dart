import 'package:flutter/material.dart';

class Word extends StatelessWidget {
  final String eng, kor;
  final int id, day;
  final bool isDone;
  const Word({
    super.key,
    required this.eng,
    required this.kor,
    required this.id,
    required this.day,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Column(
                children: [
                  Text('아이디'),
                  Text('날짜'),
                  Text('영어'),
                  Text('한글'),
                  Text('완료여부'),
                ],
              ),
              Column(
                children: [
                  Text(id.toString()),
                  Text(day.toString()),
                  Text(eng.toString()),
                  Text(kor.toString()),
                  Text(isDone.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
