import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/behavior_model.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/services/show_dialog.dart';
import 'package:usms_app/utils/store_provider.dart';

class StoreService {
  static const baseUrl = MyApp.url;
  static const storage = FlutterSecureStorage();

  // 매장 생성
  requestStore({
    required BuildContext context,
    required FormData formData,
    required int uid,
  }) async {
    var jSessionId = await storage.read(key: 'cookie');
    print('sessionid : $jSessionId');
    var cnt = 0;
    for (var field in formData.fields) {
      print('[$cnt] ${field.key}: ${field.value}');
      cnt += 1;
    }

    for (var file in formData.files) {
      print('[$cnt] ${file.key}: ${file.value}');
      cnt += 1;
    }
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        "Content-Type": "multipart/form-data;",
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );

    Dio dio = Dio(baseoptions);
    try {
      response = await dio.post('/api/users/$uid/stores', data: formData);
      if (response.statusCode! ~/ 100 == 2) {
        print('====================requestStore 200=====================');
        // print(response.data);
        Store newStore = Store.fromMap(response.data);

        Future.microtask(() {
          Provider.of<StoreProvider>(context, listen: false).addStore(newStore);
          customShowDialog(
              context: context,
              title: '매장 생성 성공',
              message: '매장 생성에 성공하였습니다.',
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              });
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '매장 생성 오류',
              message: '${e.response?.data['message']}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '서버 오류',
              message: '$e',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }

  // 특정 회원이 소유한 매장들 조회
  Future<List<Store>?> getStoresByUserId(
      {required BuildContext context, required int uid}) async {
    var jSessionId = await storage.read(key: 'cookie');
    print('[PROVIDER UID = $uid] ');
    print('[JSESSION_ID = $jSessionId] ');

    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'offset': 0,
      'size': 10,
    };

    try {
      List<Store> storeList;
      response = await dio.get(
        '/api/users/$uid/stores',
        queryParameters: param,
      );
      if (response.statusCode == 200) {
        print('=================특정 회원이 소유한 매장들 조회 200=================');
        // List<Mape<String, dynamic>> stores
        print('${response.data}');
        storeList = Store.fromMapToStoreModel(response.data);
        for (Store store in storeList) {
          print(
              'Store ID: ${store.id}, Name: ${store.name}, Address: ${store.address} BusinessLicenseCode: ${store.businessLicenseCode}, storeState: ${store.storeState}');
        }
        Provider.of<StoreProvider>(context, listen: false).storeList =
            storeList;

        return storeList;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '잘못된 요청입니다.',
              message: e.response!.data['message'],
              onPressed: () {
                Navigator.pop(context);
              });
          return null;
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '서버 오류',
              message: '유저 정보를 불러오는데 실패하였습니다.\n ${e.message}',
              onPressed: () {
                Navigator.pop(context);
              });
          return null;
        });
      }
    }
    return null;
  }

  // 특정 매장 정보 조회
  static Future<Store?> getStoreInfo(
      {required BuildContext context,
      required int uid,
      required int storeId}) async {
    var jSessionId = await storage.read(key: 'cookie');

    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    try {
      response = await dio.get('/api/users/$uid/stores/$storeId');
      if (response.statusCode! ~/ 100 == 2) {
        // print(
        //     '====================StoreGetService response 200=====================');
        // List<Mape<String, dynamic>> stores
        print(response.data);
        Store store = Store.fromMap(response.data);
        return store;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: 'BAD REQUEST',
              message: '${e.response!.data['message']}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '서버 오류',
              message: '매장 정보를 불러오는데 실패하였습니다.',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
    return null;
  }

  // 매장 삭제
  static deleteStore({
    required BuildContext context,
    required int uid,
    required int storeId,
  }) async {
    var jSessionId = await storage.read(key: 'cookie');

    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': jSessionId,
      },
      baseUrl: baseUrl,
    );
    Dio dio = Dio(baseoptions);

    try {
      response = await dio.delete('/api/users/$uid/stores/$storeId');
      if (response.statusCode! ~/ 100 == 2) {
        print('=============StoreDelete response 200=============');

        // List<Mape<String, dynamic>> stores
        Future.microtask(() {
          Provider.of<StoreProvider>(context, listen: false)
              .removeStore(storeId);
          customShowDialog(
              context: context,
              title: '매장 삭제 완료',
              message: '매장 삭제가 성공적으로 완료되었습니다.',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: 'BAD REQUEST',
              message: '${e.response!.data['message']}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '오류 메시지',
              message: '매장 삭제 실패 : ${e.response}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
      }
    }
  }

  // 매장별 이상 행동 조회
  static Future<List<BehaviorModel>?> getAllBehaviorsByStore({
    required BuildContext context,
    required int storeId,
    required int userId,
    required String startDate,
    required String endDate,
    required List<String> behaviorCodes,
  }) async {
    Map<String, int> switchStringToCode = {
      '입실': 0,
      '퇴실': 1,
      '폭행, 싸움': 2,
      '절도, 강도': 3,
      '기물 파손': 4,
      '실신': 5,
      '투기': 6,
      '주취행동': 7,
    };
    List<int> codeList = [];
    for (String code in behaviorCodes) {
      if (switchStringToCode.containsKey(code)) {
        codeList.add(switchStringToCode[code]!);
      }
    }
    print('파라미터 코드 리스트 : $codeList');

    List<BehaviorModel> behaviors = [];
    print('storeId : $storeId, userId : $userId');
    print(
        'startDate : $startDate, endDate : $endDate, BehaviorCode : $behaviorCodes');

    var jSessionId = await storage.read(key: 'cookie');
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        "Content-Type": "multipart/form-data;",
        "cookie": jSessionId,
      },
      baseUrl: baseUrl,
    );

    Dio dio = Dio(baseoptions);

    Map<String, dynamic> param = {
      'offset': 0,
      'size': 20,
    };
    if (behaviorCodes.isNotEmpty) {
      param['behaviorCode'] = codeList;
    }

    if (startDate != 'null') {
      param['startDate'] = startDate;
    }

    if (endDate != 'null') {
      param['endDate'] = endDate;
    }

    print(param);

    try {
      response = await dio.get('/api/users/$userId/stores/$storeId/accidents',
          queryParameters: param);
      if (response.statusCode! ~/ 100 == 2) {
        print('==========GetBehavior response 200===========');
        // List<Mape<String, dynamic>> stores
        return behaviors;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode! ~/ 100 == 4) {
        // print("[Error] : [$e]");
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '이상행동 조회를 실패하였습니다.',
              message: '${e.response!.data['message']}',
              onPressed: () {
                Navigator.pop(context);
              });
        });
        return null;
      } else {
        Future.microtask(() {
          customShowDialog(
              context: context,
              title: '서버 오류',
              message: '$e',
              onPressed: () {
                Navigator.pop(context);
              });
        });
        print('서버 없음');
        return null;
      }
    }
    return null;
  }

  // provider 써보기
}
