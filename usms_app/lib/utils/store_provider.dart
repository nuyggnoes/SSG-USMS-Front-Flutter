import 'package:flutter/material.dart';
import 'package:usms_app/models/store_model.dart';

class StoreProvider with ChangeNotifier {
  List<Store> _storeList = [];

  List<Store> get storeList => _storeList;
  set storeList(value) {
    _storeList = value;
    notifyListeners();
  }

  void addStore(Store newStore) {
    _storeList.add(newStore);
    notifyListeners();
  }

  void removeStore(int storeId) {
    _storeList.removeWhere((store) => store.id == storeId);

    notifyListeners();
  }
}
