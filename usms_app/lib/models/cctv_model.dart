class CCTV {
  final int cctvId;
  final int storeId;
  final String cctvName;
  final String cctvStreamKey;
  final bool isExpire;

  CCTV({
    required this.cctvId,
    required this.storeId,
    required this.cctvName,
    required this.cctvStreamKey,
    required this.isExpire,
  });

  CCTV.fromJson(Map<String, dynamic> json)
      : cctvId = json['cctvId'],
        storeId = json["storeId"],
        cctvName = json['cctvName'],
        cctvStreamKey = json['cctvStreamKey'],
        isExpire = json['isExpire'];

  Map<String, dynamic> toJson() => {
        'cctvId': cctvId,
        'cctvName': cctvName,
        'storeId': storeId,
        'cctvStreamKey': cctvStreamKey,
        'isExpire': isExpire,
      };
  factory CCTV.fromMap(Map<String, dynamic> map) {
    return CCTV(
      cctvId: map['cctvId'],
      cctvName: map['cctvName'],
      storeId: map['storeId'],
      cctvStreamKey: map['cctvStreamKey'],
      isExpire: map['isExpire'],
    );
  }
  static List<CCTV> fromMapToCCTVModel(List<Map<String, dynamic>> list) {
    List<CCTV> storeList = list.map((json) => CCTV.fromMap(json)).toList();
    return storeList;
  }
}
