import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:usms_app/models/statistic_model.dart';
import 'package:usms_app/services/store_service.dart';
import 'package:usms_app/utils/random_color.dart';

class BehaviorChart extends StatefulWidget {
  const BehaviorChart({
    super.key,
    required this.behaviorDatas,
  });
  final List<StatisticModel> behaviorDatas;

  @override
  State<StatefulWidget> createState() => BehaviorChartState();
}

class BehaviorChartState extends State<BehaviorChart> {
  int touchedIndex = -1;
  double allCounts = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 3,
                centerSpaceRadius: 80,
                sections: showingSections(),
              ),
            ),
          ),
          widget.behaviorDatas.isNotEmpty
              ? SizedBox(
                  height: 55,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '총 ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${allCounts.round()}회',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        ),
                      ),
                      const Text(
                        '의 이상행동 발생',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: List.generate(
              widget.behaviorDatas.length,
              (index) => Indicator(
                color: colorList[index]!,
                statDataList: widget.behaviorDatas,
                index: index,
              ),
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    allCounts = widget.behaviorDatas.fold(0, (sum, model) => sum + model.count);
    List<int> percents = widget.behaviorDatas
        .map((e) => (e.count / allCounts * 100).round())
        .toList();
    return List.generate(
      widget.behaviorDatas.length,
      (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: colorList[i],
              value: percents[i].toDouble(),
              title: '${percents[i]} %',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 1:
            return PieChartSectionData(
              color: colorList[i],
              value: percents[i].toDouble(),
              title: '${percents[i]} %',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 2:
            return PieChartSectionData(
              color: colorList[i],
              value: percents[i].toDouble(),
              title: '${percents[i]} %',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          case 3:
            return PieChartSectionData(
              color: colorList[i],
              value: percents[i].toDouble(),
              title: '${percents[i]} %',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            );
          default:
            throw Error();
        }
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final List<StatisticModel> statDataList;
  final int index;

  const Indicator({
    super.key,
    required this.color,
    required this.statDataList,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    Map<int, String> intToString = StoreService.reversedMap;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text('${intToString[statDataList[index].behavior]}'),
            ],
          ),
          Text('${statDataList[index].count} 회'),
        ],
      ),
    );
  }
}
