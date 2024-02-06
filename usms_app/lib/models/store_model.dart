import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  int? id;
  String? adminComment;
  final int userId;
  final String name;
  final String address;
  final String businessLicenseCode;
  final String businessLicenseImgId;
  final int storeState;

  Store({
    this.id,
    this.adminComment,
    required this.userId,
    required this.name,
    required this.address,
    required this.businessLicenseCode,
    required this.businessLicenseImgId,
    required this.storeState,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'address': address,
        'businessLicenseCode': businessLicenseCode,
        'businessLicenseImgId': businessLicenseImgId,
        'storeState': storeState,
      };
  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      address: map['address'],
      businessLicenseCode: map['businessLicenseCode'],
      businessLicenseImgId: map['businessLicenseImgId'],
      storeState: map['storeState'],
      adminComment: map['adminComment'],
    );
  }
  static List<Store> fromMapToStoreModel(List<dynamic> list) {
    List<Store> storeList = list.map((json) {
      return Store.fromMap(json);
    }).toList();

    return storeList;
  }
}
