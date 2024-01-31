class StatisticModel {
  String? region;
  int behaviorCode;
  String? endDate;
  String? startDate;
  int count;

  StatisticModel({
    required this.count,
    this.endDate,
    this.region,
    this.startDate,
    required this.behaviorCode,
  });

  // Map<String, dynamic> toJson() => {
  //       'behaviorCode': behaviorCodeList,
  //       'startDate': startDate,
  //       'endDate': endDate,
  //     };
  factory StatisticModel.fromMap(Map<String, dynamic> map) {
    return StatisticModel(
      region: map['storeId'],
      behaviorCode: map['behaviorCode'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      count: map['count'],
    );
  }

  static List<StatisticModel> fromMapToRegionModel(List<dynamic> list) {
    List<StatisticModel> storeList =
        list.map((json) => StatisticModel.fromMap(json)).toList();
    return storeList;
  }
}
