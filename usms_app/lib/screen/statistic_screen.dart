import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:usms_app/models/word_model.dart';
import 'package:usms_app/service/word_json.dart';

class StatisticScreen extends StatefulWidget {
  static const route = 'statistic-screen';
  const StatisticScreen({super.key});

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
  Future<List<WordModel>>? words;
  int? tappedIndex = -1;

  @override
  void initState() {
    super.initState();
    words = WordJson.getWords();
  }

  @override
  Widget build(BuildContext context) {
    int totalSales =
        data.map((salesData) => salesData.sales).fold(0, (a, b) => a + b);
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계 지표'),
        centerTitle: true,
        leading: const Icon(Icons.bar_chart_rounded),
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
              future: words,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final Map<int, int> wordCountByDay = {};
                  for (var word in snapshot.data!) {
                    final day = word.day;
                    wordCountByDay[day] = (wordCountByDay[day] ?? 0) + 1;
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
                        // pointColorMapper: (WordModel word, _) =>
                        //     word.isHighlighted
                        //         ? Colors.blue // Highlighted color
                        //         : Colors.green, // Default color
                        // // Implement onTap callback if needed
                        // selectionSettings: SelectionSettings(
                        //   enable: true,
                        //   unselectedColor: Colors.green.withOpacity(0.6),
                        // ),
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
