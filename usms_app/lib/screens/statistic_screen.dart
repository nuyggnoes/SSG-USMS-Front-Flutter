import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:usms_app/models/statistic_model.dart';
import 'package:usms_app/models/word_model.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/services/word_json.dart';
import 'package:usms_app/utils/user_provider.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key, required this.storeId, required this.uid});
  final int storeId;
  final int uid;
  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  List<_SalesData> data = [
    _SalesData('행동1', 2),
    _SalesData('행동2', 2),
    _SalesData('행동3', 3),
    _SalesData('행동4', 4),
  ];
  // 각 행동들의 날짜(기간)에 대한 count
  // var dummy = [
  //   {
  //     "storeId": 1,
  //     "behaviorCode": 0,
  //     "count": 50,
  //     "startDate": "2023-12-01",
  //     "endDate": "2024-01-31"
  //   },
  //   {
  //     "storeId": 1,
  //     "behaviorCode": 3,
  //     "count": 30,
  //     "startDate": "2023-12-01",
  //     "endDate": "2024-01-31"
  //   },
  //   {
  //     "storeId": 1,
  //     "behaviorCode": 7,
  //     "count": 60,
  //     "startDate": "2023-12-01",
  //     "endDate": "2024-01-31"
  //   }
  // ];
  Future<List<StatisticModel>?>? statisticData;
  Future<List<WordModel>>? words;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = null;
    _endDate = null;

    statisticData = StoreService.getStoreStatistics(
        context: context,
        storeId: widget.storeId,
        userId: widget.uid,
        startDate: _startDate.toString().split(" ").first,
        endDate: _endDate.toString().split(" ").first);

    // statisticData = StoreService.
  }

  @override
  Widget build(BuildContext context) {
    int totalSales =
        data.map((salesData) => salesData.sales).fold(0, (a, b) => a + b);
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계 지표'),
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
          Expanded(
            child: Row(
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
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
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
                          : DateFormat('yyyy-MM-dd').format(_startDate!),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                  child: Text(' -- '),
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
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        locale: const Locale('ko', 'KR'),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _endDate = selectedDate;
                        });
                      }
                    },
                    child: Text(
                      _endDate == null
                          ? ''
                          : DateFormat('yyyy-MM-dd').format(_endDate!),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
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
                  onPressed: () {
                    String startDateString;
                    String endtDateString;
                    startDateString = _startDate.toString().split(" ").first;
                    endtDateString = _endDate.toString().split(" ").first;
                    print('[SELECT DATE] : $_startDate ~ $_endDate');
                    print('[SELECT DATE] : $startDateString,$endtDateString');
                    // StoreService.getStoreStatistics(
                    //     context: context,
                    //     storeId: widget.storeId,
                    //     userId: Provider.of<UserProvider>(context).user.id!,
                    //     startDate: _startDate.toString().split(" ").first,
                    //     endDate: _endDate.toString().split(" ").first);
                  },
                  child: const Text(
                    '조회',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Text('$statisticData'),
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
          Expanded(
            child: FutureBuilder(
              future: statisticData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final Map<int, int> wordCountByDay = {};
                  final Map<int, int> behaviorCount = {};
                  for (var data in snapshot.data!) {
                    final code = data.behavior;
                    wordCountByDay[code] = (wordCountByDay[code] ?? 0) + 1;
                  }
                  return SfCircularChart(
                    legend: const Legend(isVisible: true),
                    series: <DoughnutSeries<MapEntry<int, int>, String>>[
                      DoughnutSeries<MapEntry<int, int>, String>(
                        dataSource: wordCountByDay.entries.toList(),
                        xValueMapper: (entry, _) => entry.key.toString(),
                        yValueMapper: (entry, _) => entry.value,
                        dataLabelMapper: (entry, _) =>
                            '${entry.key}일차 단어 : ${entry.value}개',
                        enableTooltip: true,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        explode: true,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final int sales;
}
