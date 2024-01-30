import 'package:flutter/material.dart';

class Region extends StatelessWidget {
  final String cctvName;
  final String behavior;
  final String date;

  const Region({
    super.key,
    required this.date,
    required this.cctvName,
    required this.behavior,
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
                  Text('일시'),
                  Text('CCTV명'),
                  Text('행동'),
                ],
              ),
              Column(
                children: [
                  Text(date),
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
