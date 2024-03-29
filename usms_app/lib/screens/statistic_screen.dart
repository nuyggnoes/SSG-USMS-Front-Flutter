import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'package:usms_app/models/statistic_model.dart';

import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/widget/pie_chart_widget.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key, required this.storeId, required this.uid});
  final int storeId;
  final int uid;
  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  Future<List<StatisticModel>?>? statisticData;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = null;
    _endDate = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    statisticData = _fetchStatistic();
  }

  Future<List<StatisticModel>?> _fetchStatistic() async {
    var returnValue = await StoreService.getStoreStatistics(
        context: context,
        storeId: widget.storeId,
        userId: widget.uid,
        startDate: _startDate.toString().split(" ").first,
        endDate: _endDate.toString().split(" ").first);
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('매장 이상행동 통계'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.grey),
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
                      final selectedDate = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime.now(),
                        locale: const Locale('ko', 'KR'),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _startDate = selectedDate;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _startDate == null
                              ? ''
                              : DateFormat('yy년 M월').format(_startDate!),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.grey),
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
                      final selectedDate = await showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        locale: const Locale('ko', 'KR'),
                      );
                      if (selectedDate != null) {
                        var lastDayOfMonth = DateTime(
                            selectedDate.year, selectedDate.month + 1, 0);
                        setState(() {
                          _endDate = lastDayOfMonth;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _endDate == null
                              ? ''
                              : DateFormat('yy년 M월').format(_endDate!),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.blueAccent,
                    ),
                    side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.blueAccent),
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
                    statisticData = _fetchStatistic();
                    setState(() {});
                  },
                  child: const Text(
                    '조회',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: statisticData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SpinKitWave(
                    color: Colors.blueAccent,
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(
                      child: Text('집계된 데이터가 없습니다.'),
                    ),
                  );
                } else {
                  final List<StatisticModel> data = snapshot.data!;
                  final Map<String, int> behaviorCount = {};
                  final Map<int, int> wordCountByDay = {};

                  for (var stat in data) {
                    final behavior = StoreService.reversedMap[stat.behavior]!;
                    behaviorCount[behavior] =
                        (behaviorCount[behavior] ?? 0) + stat.count;
                  }

                  for (var data in snapshot.data!) {
                    final code = data.behavior;
                    wordCountByDay[code] = (wordCountByDay[code] ?? 0) + 1;
                  }
                  return BehaviorChart(behaviorDatas: data);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
