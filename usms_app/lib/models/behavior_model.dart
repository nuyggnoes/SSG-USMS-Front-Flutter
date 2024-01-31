class StoreNotification {
  int? id;
  int? cctvId;
  String? startDate;
  String? endDate;
  List<int>? behaviorCodeList;
  int behaviorCode;
  final String cctvName = '';
  final DateTime eventTimestamp;

  StoreNotification({
    required this.eventTimestamp,
    this.behaviorCodeList,
    this.id,
    this.cctvId,
    this.startDate,
    this.endDate,
    this.behaviorCode = -1,
  });

  Map<String, dynamic> toJson() => {
        'behaviorCode': behaviorCodeList,
        'startDate': startDate,
        'endDate': endDate,
      };
  factory StoreNotification.fromMap(Map<String, dynamic> map) {
    return StoreNotification(
      id: map['id'],
      cctvId: map['cctvId'],
      eventTimestamp: map['eventTimestamp'],
      behaviorCode: map['behaviorCode'],
    );
  }

  static List<StoreNotification> fromMapToStoreNotificationModel(
      List<dynamic> list) {
    List<StoreNotification> storeList = list.map((json) {
      return StoreNotification.fromMap(json);
    }).toList();

    return storeList;
  }
}
