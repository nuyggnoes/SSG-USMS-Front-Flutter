class StatisticModel {
  int storeId;
  int behavior;
  int count;
  String? startDate;
  String? endDate;

  StatisticModel({
    required this.count,
    this.endDate,
    this.startDate,
    this.storeId = -1,
    required this.behavior,
  });

  factory StatisticModel.fromMap(Map<String, dynamic> map) {
    return StatisticModel(
      storeId: map['storeId'],
      behavior: map['behavior'],
      count: map['count'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }

  static List<StatisticModel> fromMapToRegionModel(List<dynamic> list) {
    List<StatisticModel> storeList =
        list.map((json) => StatisticModel.fromMap(json)).toList();
    return storeList;
  }
}
