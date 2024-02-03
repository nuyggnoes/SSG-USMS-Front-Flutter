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

  @override
  Widget build(BuildContext context) {
    print('behavior datas ${widget.behaviorDatas}');
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
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
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.behaviorDatas.length,
              (index) => Column(
                children: [
                  Indicator(
                    color: colorList[index]!,
                    statDataList: widget.behaviorDatas,
                    index: index,
                  ),
                ],
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
    double allCounts =
        widget.behaviorDatas.fold(0, (sum, model) => sum + model.count);
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
              title: '${percents[i]} %\n(${widget.behaviorDatas[i].count})',
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
              title: '${percents[i]} %\n(${widget.behaviorDatas[i].count})',
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
              title: '${percents[i]} %\n(${widget.behaviorDatas[i].count})',
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
              title: '${percents[i]} %\n(${widget.behaviorDatas[i].count})',
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
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: color),
        ),
        Text('${intToString[statDataList[index].behavior]}'),
      ],
    );
  }
}
