import 'package:flutter/material.dart';

class Region extends StatelessWidget {
  final int count;
  final String behavior;
  final String date;
  final String region;

  const Region({
    super.key,
    required this.date,
    required this.count,
    required this.behavior,
    required this.region,
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
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.amber,
                  size: 60,
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '지역알림',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '[$date] $region에서 \n[ $behavior ] 이(가) $count건 발생했습니다.',
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
