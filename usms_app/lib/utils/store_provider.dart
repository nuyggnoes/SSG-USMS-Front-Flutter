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

  void removeStore(Store selectedStore) {
    _storeList.remove(selectedStore);
    notifyListeners();
  }

  // 여기서 비동기로 api 요청을 보내서 미리 List<Store>를 전달받고 Screen 단에서 Provider의 getter를 통해 List<Store>를 뿌려준다.
}
