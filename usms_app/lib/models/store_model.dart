import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  int? storeId;
  String? storeMessage;
  final int user_id;
  final String store_name;
  final String store_address;
  final String store_register_code;
  final int store_registration_img_id;
  final int store_state;

  Store({
    this.storeId,
    this.storeMessage,
    required this.user_id,
    required this.store_name,
    required this.store_address,
    required this.store_register_code,
    required this.store_registration_img_id,
    required this.store_state,
  });

  Store.fromJson(Map<String, dynamic> json)
      : storeId = json['storeId'],
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
      user_id: map['user_id'],
      store_name: map['name'],
      store_address: map['address'],
      store_register_code: map['registrationCode'],
      store_registration_img_id: map['registrationImgId'],
      store_state: map['state'],
      storeMessage: map['message'],
    );
  }
  static List<Store> fromMapToStoreModel(List<Map<String, dynamic>> list) {
    List<Store> storeList = list.map((json) => Store.fromMap(json)).toList();
    return storeList;
  }
}
