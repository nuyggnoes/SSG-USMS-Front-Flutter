import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
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
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.grey.shade500),
              ),
            ),
            child: const Center(
              child: Text('이상감지 현황'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
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
                    final selectedDate = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      locale: const Locale('ko', 'KR'),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _startDate = selectedDate;
                      });
                    }
                  },
                  child: Text(
                    _startDate == null
                        ? ''
                        : DateFormat('yy년 M월').format(_startDate!),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
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
                      print(lastDayOfMonth);
                      setState(() {
                        _endDate = lastDayOfMonth;
                      });
                    }
                  },
                  child: Text(
                    _endDate == null
                        ? ''
                        : DateFormat('yy년 M월').format(_endDate!),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              ElevatedButton(
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
                  String startDateString;
                  String endtDateString;
                  startDateString = _startDate.toString().split(" ").first;
                  endtDateString = _endDate.toString().split(" ").first;
                  print('[SELECT DATE] : $_startDate ~ $_endDate');
                  print('[SELECT DATE] : $startDateString,$endtDateString');
                  statisticData = _fetchStatistic();
                  setState(() {});
                },
                child: const Text(
                  '조회',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          // Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     SfCircularChart(
          //       legend: const Legend(
          //         isVisible: true,
          //       ),
          //       series: <DoughnutSeries<_SalesData, String>>[
          //         DoughnutSeries<_SalesData, String>(
          //           dataSource: data,
          //           xValueMapper: (_SalesData sales, _) => sales.year,
          //           yValueMapper: (_SalesData sales, _) => sales.sales,
          //           dataLabelMapper: (_SalesData sales, _) =>
          //               '${sales.year}: ${sales.sales}',
          //           enableTooltip: true,
          //           dataLabelSettings: const DataLabelSettings(isVisible: true),
          //           explode: true,
          //         ),
          //       ],
          //     ),
          //     Container(
          //       child: Text('$totalSales'),
          //     ),
          //   ],
          // ),
          FutureBuilder(
            future: statisticData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<StatisticModel> data = snapshot.data!;
                final Map<String, int> behaviorCount = {};
                final Map<int, int> wordCountByDay = {};
                print('이상행동 : ${StoreService.reversedMap}');

                for (var stat in data) {
                  final behavior = StoreService.reversedMap[stat.behavior]!;
                  behaviorCount[behavior] =
                      (behaviorCount[behavior] ?? 0) + stat.count;
                }

                for (var data in snapshot.data!) {
                  final code = data.behavior;
                  wordCountByDay[code] = (wordCountByDay[code] ?? 0) + 1;
                }
                // return SfCircularChart(
                //   legend: const Legend(isVisible: true),
                //   series: <DoughnutSeries<MapEntry<String, int>, String>>[
                //     DoughnutSeries<MapEntry<String, int>, String>(
                //       dataSource: behaviorCount.entries.toList(),
                //       xValueMapper: (entry, _) => entry.key.toString(),
                //       yValueMapper: (entry, _) => entry.value,
                //       dataLabelMapper: (entry, _) =>
                //           '${entry.key} : ${entry.value}개',
                //       enableTooltip: true,
                //       dataLabelSettings:
                //           const DataLabelSettings(isVisible: true),
                //       // explode: true,
                //     ),
                //   ],
                // );
                return BehaviorChart(behaviorDatas: data);
              }
            },
          ),
        ],
      ),
    );
  }
}

List<Sector> testSector = [
  Sector(),
  Sector(),
  Sector(),
  Sector(),
  Sector(),
];

Color getRandomColor() {
  Random random = Random();
  int red = random.nextInt(256);
  int green = random.nextInt(256);
  int blue = random.nextInt(256);

  return Color.fromARGB(255, red, green, blue);
}

class Sector {
  Color color = getRandomColor();
  double value = 12.0;
}

class PieChartWidget extends StatelessWidget {
  final List<Sector> sectors;

  const PieChartWidget(this.sectors, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: PieChart(
        PieChartData(
          sections: _chartSections(sectors),
          centerSpaceRadius: 50.0,
        ),
      ),
    );
  }

  List<PieChartSectionData> _chartSections(List<Sector> sectors) {
    final List<PieChartSectionData> list = [];
    for (var sector in sectors) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        color: sector.color,
        value: sector.value,
        radius: radius,
        title: 'hello',
      );
      list.add(data);
    }
    return list;
  }
}
