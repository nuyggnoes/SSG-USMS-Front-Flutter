import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  final int store_id;
  final int user_id;
  final String store_name;
  final String store_address;
  final String store_register_code;
  final int store_registration_img_id;
  final int store_state;

  Store({
    required this.store_id,
    required this.user_id,
    required this.store_name,
    required this.store_address,
    required this.store_register_code,
    required this.store_registration_img_id,
    required this.store_state,
  });

  Store.fromJson(Map<String, dynamic> json)
      : store_id = json['store_id'],
        user_id = json["user_id"],
        store_name = json['store_name'],
        store_address = json['store_address'],
        store_register_code = json['store_register_code'],
        store_registration_img_id = json['store_registration_img_id'],
        store_state = json['store_state'];

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'store_name': store_name,
        'store_address': store_address,
        'store_register_code': store_register_code,
        'store_registration_img_id': store_registration_img_id,
        'store_state': store_state,
      };
  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      store_id: map['store_id'],
      user_id: map['user_id'],
      store_name: map['store_name'],
      store_address: map['store_address'],
      store_register_code: map['store_register_code'],
      store_registration_img_id: map['store_registration_img_id'],
      store_state: map['store_state'],
    );
  }
  static List<Store> fromMapToStoreModel(List<Map<String, dynamic>> list) {
    List<Store> storeList = list.map((json) => Store.fromMap(json)).toList();
    return storeList;
  }
}
