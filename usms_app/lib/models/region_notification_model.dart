class RegionNotification {
  String? region;
  int behaviorCode;
  String? startDate;
  String? endDate;
  String date;
  int count;

  RegionNotification({
    required this.date,
    required this.count,
    this.startDate,
    this.endDate,
    this.region,
    required this.behaviorCode,
  });

  factory RegionNotification.fromMap(Map<String, dynamic> map) {
    return RegionNotification(
      region: map['region'],
      behaviorCode: map['behavior'],
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
