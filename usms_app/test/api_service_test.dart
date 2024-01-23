// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:dio/dio.dart';
// import 'package:usms_app/services/store_service.dart';
// import 'package:usms_app/models/store_model.dart';

// class MockDio extends Mock implements Dio {}

// class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

// void main() {
//   group('StoreService Tests', () {
//     late StoreService storeService;
//     late MockDio mockDio;
//     late MockFlutterSecureStorage mockStorage;

//     setUp(() {
//       mockDio = MockDio();
//       mockStorage = MockFlutterSecureStorage();
//       storeService = StoreService();
//       // storeService.dio = mockDio;
//       // storeService.storage = mockStorage;
//     });

//     test(
//         'getUserStoresById returns List<Store> if HTTP call completes successfully',
//         () async {
//       const int uid = 1;
//       final List<Store> expectedStoreList = [
//         Store(
//             store_id: 1,
//             user_id: 1,
//             store_name: 'GS25 무인매장',
//             store_address: '부산광역시 남구',
//             store_register_code: '1-22-333-4444',
//             store_registration_img_id: 1,
//             store_state: 0 /* populate with necessary fields */),
//         Store(
//             store_id: 2,
//             user_id: 1,
//             store_name: 'GS25 무인매장2',
//             store_address: '부산광역시 사하구',
//             store_register_code: '4444-333-22-1',
//             store_registration_img_id: 2,
//             store_state: 1 /* populate with necessary fields */),
//       ];

//       // Mocking FlutterSecureStorage
//       when(mockStorage.read(key: 'cookie'))
//           .thenAnswer((_) async => 'mocked_cookie_value');

//       // Mocking Dio
//       when(mockDio.get(
//         '/api/users/$uid/stores',
//         data: {'offset': 0, 'size': 10},
//         options: anyNamed('options'),
//       )).thenAnswer(
//         (_) async => Response(
//             data: expectedStoreList,
//             statusCode: 200,
//             requestOptions:
//                 RequestOptions(baseUrl: 'https://usms.serveftp.com')),
//       );

//       final result = await storeService.getUserStoresById(uid);

//       expect(result, equals(expectedStoreList));
//     });

//     test('getUserStoresById returns null on HTTP error', () async {
//       const int uid = 1;

//       // Mocking FlutterSecureStorage
//       when(mockStorage.read(key: 'cookie'))
//           .thenAnswer((_) async => 'mocked_cookie_value');

//       // Mocking Dio
//       when(mockDio.get(
//         '/api/users/$uid/stores',
//         data: {'offset': 0, 'size': 10},
//         options: anyNamed('options'),
//       )).thenAnswer(
//         (_) async => Response(
//             data: null,
//             statusCode: 400,
//             requestOptions: RequestOptions(
//                 baseUrl: 'https://usms.serveftp.com')), // HTTP error response
//       );

//       final result = await storeService.getUserStoresById(uid);

//       expect(result, isNull);
//     });

//     test('getStoreInfo returns Store if HTTP call completes successfully',
//         () async {
//       const int uid = 1;
//       const int storeId = 123;
//       final Store expectedStore = Store(
//           store_id: 1,
//           user_id: 1,
//           store_name: 'GS25 무인매장',
//           store_address: '부산광역시 남구',
//           store_register_code: '1-22-333-4444',
//           store_registration_img_id: 1,
//           store_state: 0 /* populate with necessary fields */);

//       // Mocking FlutterSecureStorage
//       when(mockStorage.read(key: 'cookie'))
//           .thenAnswer((_) async => 'mocked_cookie_value');

//       // Mocking Dio
//       when(mockDio.get(
//         '/api/users/$uid/stores/$storeId',
//         options: anyNamed('options'),
//       )).thenAnswer(
//         (_) async => Response(
//             data: expectedStore,
//             statusCode: 200,
//             requestOptions:
//                 RequestOptions(baseUrl: 'https://usms.serveftp.com')),
//       );

//       final result = await storeService.getStoreInfo(uid, storeId);

//       expect(result, equals(expectedStore));
//     });

//     test('getStoreInfo returns null on HTTP error', () async {
//       const int uid = 1;
//       const int storeId = 123;

//       // Mocking FlutterSecureStorage
//       when(mockStorage.read(key: 'cookie'))
//           .thenAnswer((_) async => 'mocked_cookie_value');

//       // Mocking Dio
//       when(mockDio.get(
//         '/api/users/$uid/stores/$storeId',
//         options: anyNamed('options'),
//       )).thenAnswer(
//         (_) async => Response(
//             data: null,
//             statusCode: 404,
//             requestOptions: RequestOptions(
//                 baseUrl: 'https://usms.serveftp.com')), // HTTP error response
//       );

//       final result = await storeService.getStoreInfo(uid, storeId);

//       expect(result, isNull);
//     });
//   });
// }
