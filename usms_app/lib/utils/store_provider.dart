import 'package:flutter/material.dart';
import 'package:usms_app/models/store_model.dart';

class StoreProvider with ChangeNotifier {
  final List<Store> _storeList = [];

  List<Store> get storeList => _storeList;

  void updateStore(Store newStore) {
    _storeList.add(newStore);
    notifyListeners();
  }
}
