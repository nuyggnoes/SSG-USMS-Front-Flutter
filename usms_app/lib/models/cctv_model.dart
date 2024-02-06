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

  static List<String> cctvIdTocctvName(
    List<int> cctvIdList,
    List<CCTV> cctvList,
  ) {
    List<String> cctvNames = [];
    for (int cctvId in cctvIdList) {
      CCTV? cctv = cctvList.firstWhere((cctv) => cctv.cctvId == cctvId);

      // CCTV가 존재하면 이름을 cctvNames에 추가
      cctvNames.add(cctv.cctvName);
    }
    print(cctvNames);

    return cctvNames;
  }
}
