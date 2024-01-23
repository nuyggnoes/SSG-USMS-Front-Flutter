import 'package:flutter/material.dart';
import 'package:usms_app/models/store_model.dart';

class StoreProvider with ChangeNotifier {
  Store _store = Store(
      user_id: -1,
      store_name: '',
      store_address: '',
      store_register_code: '',
      store_registration_img_id: -1,
      store_state: -1);

  Store get store => _store;

  void updateStore(Store newStore) {
    _store = newStore;
    notifyListeners();
  }
}
