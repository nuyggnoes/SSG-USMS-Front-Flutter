class RegionNotification {
  String? region;
  int? behaviorCode;
  String? startDate;
  String? endDate;
  String? date;
  int? count;

  RegionNotification({
    this.date,
    this.count,
    this.startDate,
    this.endDate,
    this.region,
    this.behaviorCode,
  });

  // Map<String, dynamic> toJson() => {
  //       'behaviorCode': behaviorCodeList,
  //       'startDate': startDate,
  //       'endDate': endDate,
  //     };
  factory RegionNotification.fromMap(Map<String, dynamic> map) {
    return RegionNotification(
      region: map['region'],
      behaviorCode: map['behaviorCode'],
      date: map['date'],
      count: map['count'],
    );
  }

  static List<RegionNotification> fromMapToRegionModel(List<dynamic> list) {
    List<RegionNotification> storeList =
        list.map((json) => RegionNotification.fromMap(json)).toList();
    return storeList;
  }
}
