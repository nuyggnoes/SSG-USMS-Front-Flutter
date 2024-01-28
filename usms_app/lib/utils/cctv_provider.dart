import 'package:flutter/material.dart';
import 'package:usms_app/models/cctv_model.dart';

class CCTVProvider with ChangeNotifier {
  List<CCTV> _cctvList = [];

  List<CCTV> get cctvList => _cctvList;
  set cctvList(value) {
    _cctvList = value;
    notifyListeners();
  }

  void addCCTV(CCTV newCCTV) {
    _cctvList.add(newCCTV);
    notifyListeners();
  }

  void removeCCTV(int cctvId) {
    _cctvList.removeWhere((cctv) => cctv.cctvId == cctvId);

    notifyListeners();
  }
}
