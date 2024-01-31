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
    var test = DateTime.fromMillisecondsSinceEpoch(time).toString();
    var timeStampList =
        DateTime.fromMillisecondsSinceEpoch(time).toString().split(" ");
    var date = timeStampList.first;
    var c = timeStampList.last.split(".").first;

    DateTime dateTime = DateTime.parse('$date $c');

    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    String formattedDateTime = dateFormat.format(dateTime);

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
                  Text('일시'),
                  Text('CCTV명'),
                  Text('행동'),
                ],
              ),
              Column(
                children: [
                  // Text(DateTime.fromMicrosecondsSinceEpoch(time).toString()),
                  Text(test),
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
