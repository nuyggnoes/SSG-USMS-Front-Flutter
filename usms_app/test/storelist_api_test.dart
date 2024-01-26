// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:usms_app/models/store_model.dart';

// import 'storelist_api_test.mocks.dart';

// // Dio 목(Mock) 클래스 생성
// @GenerateMocks([Dio])
// void main() {
//   group('getUserStoresById', () {
//     final Dio dioMock = MockDio();

//     // 테스트 코드 작성
//     test('returns a list of stores when the request is successful', () async {
//       // Arrange
//       final storageMock = MockFlutterSecureStorage();
//       const cookie = 'mocked_cookie';
//       when(storageMock.read(key: 'cookie')).thenAnswer((_) async => cookie);

//       final expectedResponse = Response(
//         data: [
//           {
//             'user_id': 1,
//             'store_name': 'Store1',
//             'store_address': 'address1',
//             'store_registration_code': '123-41-234',
//             'store_registration_img_id': 1,
//             'store_state': 1,
//           },
//           {
//             'user_id': 2,
//             'store_name': 'Store2',
//             'store_address': 'address2',
//             'store_registration_code': '222-33-4444',
//             'store_registration_img_id': 2,
//             'store_state': 2,
//           },
//         ],
//         statusCode: 200,
//         requestOptions: RequestOptions(
//           baseUrl: "https://usms.serveftp.com",
//         ),
//       );

//       when(dioMock.get('/api/users/stores', data: anyNamed('data'))).thenAnswer(
//         (_) async => expectedResponse,
//       );

//       // Act
//       final result = await getUserStoresById(1, dioMock, storageMock);

//       // Assert
//       expect(result, isNotEmpty);
//       expect(result[0].user_id, 1);
//       expect(result[0].store_name, 'Store1');
//       expect(result[0].store_state, 1);

//       verify(storageMock.read(key: 'cookie')).called(1);
//       verify(dioMock.get('/api/users/1/stores',
//           data: {'offset': 0, 'size': 10})).called(1);
//     });

//     // Add more test cases for error handling, etc.
//   });
// }

// // getUserStoresById 함수 정의
// Future<List<Store>> getUserStoresById(
//     int uid, Dio dio, FlutterSecureStorage storage) async {
//   var jSessionId = await storage.read(key: 'cookie');

//   Response response;
//   var baseOptions = BaseOptions(
//     headers: {
//       'Content-Type': 'application/json; charset=utf-8',
//       'cookie': jSessionId,
//     },
//     baseUrl: "http://10.0.2.2:3003",
//   );
//   dio = Dio(baseOptions);

//   var param = {
//     'offset': 0,
//     'size': 10,
//   };

//   try {
//     response = await dio.get('/api/users/$uid/stores', data: param);
//     if (response.statusCode == 200) {
//       print(
//           '====================StoreGetService response 200=====================');
//       List<Store> storeList = Store.fromMapToStoreModel(response.data);
//       return storeList;
//     }
//   } on DioError catch (e) {
//     if (e.response?.statusCode == 400) {
//       print("[Error] : [$e]");
//       return [];
//     }
//   } on SocketException catch (e) {
//     print("[Server ERR] : $e");
//     return [];
//   } catch (e) {
//     print("[Error] : [$e]");
//     return [];
//   }
//   return [];
// }

// // Mock FlutterSecureStorage 클래스 생성
// class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
