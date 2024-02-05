import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Behavior extends StatelessWidget {
  final String cctvName;
  final String behavior;
  final int time;

  const Behavior({
    super.key,
    required this.time,
    required this.cctvName,
    required this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    var timestamp = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var originalDateTimeString =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);
    DateTime originalDateTime = DateTime.parse(originalDateTimeString);
    String formattedDateTime =
        DateFormat('yyyy/M/d(E) a h시 m분', 'ko_KR').format(originalDateTime);

    return Container(
      padding: const EdgeInsets.all(10),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '일시',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'CCTV명',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '행동',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(DateTime.fromMicrosecondsSinceEpoch(time).toString()),
                  Text(formattedDateTime),
                  Text(cctvName.toString()),
                  Text(behavior),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
