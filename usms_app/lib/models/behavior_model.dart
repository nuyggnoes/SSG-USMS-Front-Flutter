class BehaviorModel {
  int? id;
  int? cctvId;
  String? startDate;
  String? endDate;
  List<int>? behaviorCodeList;
  int? behaviorCode;
  final String cctvName = '';
  final DateTime eventTimestamp;

  BehaviorModel({
    required this.eventTimestamp,
    this.behaviorCodeList,
    this.id,
    this.cctvId,
    this.startDate,
    this.endDate,
    this.behaviorCode,
  });

  Map<String, dynamic> toJson() => {
        'behaviorCode': behaviorCodeList,
        'startDate': startDate,
        'endDate': endDate,
      };
  factory BehaviorModel.fromMap(Map<String, dynamic> map) {
    return BehaviorModel(
      id: map['id'],
      cctvId: map['cctvId'],
      eventTimestamp: map['eventTimestamp'],
      behaviorCode: map['behaviorCode'],
    );
  }
}
