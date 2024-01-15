import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  int? tappedIndex = -1;
  @override
  Widget build(BuildContext context) {
    int totalSales =
        data.map((salesData) => salesData.sales).fold(0, (a, b) => a + b);
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계 지표'),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
          Stack(
            alignment: Alignment.center,
            children: [
              SfCircularChart(
                legend: const Legend(
                  isVisible: true,
                ),
                series: <DoughnutSeries<_SalesData, String>>[
                  DoughnutSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    dataLabelMapper: (_SalesData sales, _) =>
                        '${sales.year}: ${sales.sales}',
                    enableTooltip: true,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    explode: true,
                  ),
                ],
              ),
              Container(
                child: Text('$totalSales'),
              ),
            ],
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
