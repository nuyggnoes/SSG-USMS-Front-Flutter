class CCTV {
  final int cctvId;
  final int storeId;
  final String cctvName;
  final String cctvStreamKey;
  final bool isExpire;
  final bool isConnected;

  CCTV({
    this.cctvId = -1,
    required this.storeId,
    required this.cctvName,
    this.cctvStreamKey = '',
    this.isExpire = false,
    this.isConnected = false,
  });

  // CCTV.fromJson(Map<String, dynamic> json)
  //     : cctvId = json['cctvId'],
  //       storeId = json["storeId"],
  //       cctvName = json['cctvName'],
  //       cctvStreamKey = json['cctvStreamKey'],
  //       isExpire = json['isExpire'];

  Map<String, dynamic> toJson() => {
        'cctvId': cctvId,
        'cctvName': cctvName,
        'storeId': storeId,
        'cctvStreamKey': cctvStreamKey,
        'isExpire': isExpire,
      };
  factory CCTV.fromMap(Map<String, dynamic> map) {
    return CCTV(
      cctvId: map['id'],
      cctvName: map['cctvName'],
      storeId: map['storeId'],
      cctvStreamKey: map['cctvStreamKey'],
      isExpire: map['expired'],
      isConnected: map['isConnected'],
    );
  }
  static List<CCTV> fromMapToCCTVModel(List<dynamic> list) {
    List<CCTV> storeList = list.map((json) => CCTV.fromMap(json)).toList();
    return storeList;
  }
}
