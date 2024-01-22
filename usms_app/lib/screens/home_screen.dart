import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:usms_app/main.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/models/user_model.dart';

// screen
import 'package:usms_app/screens/main_screen.dart';
import 'package:usms_app/screens/notification_list_screen.dart';
import 'package:usms_app/screens/statistic_screen.dart';
import 'package:usms_app/screens/user_info_screen.dart';
import 'package:usms_app/services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const route = '/main';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  final UserService userService = UserService();
  late String? name = '';
  late String? email = '';
  late int? uid;
  int state = 0;
  late Icon securityIcon;

  late User? user;
  late Store store;
  late List<Widget> widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    try {
      userService.getUserInfo().then((value) {
        setState(() {
          user = value;
          uid = user!.uid;
          widgetOptions = <Widget>[
            MainScreen(
              uid: uid,
            ),
            const NotificationListScreen(),
            const StatisticScreen(),
            MyPageScreen(
              context: super.context,
            ),
          ];
        });
      });
    } catch (e) {
      print("Error in initState: $e");
    }
    // getUserInfo();
    // getUserStores();
  }

  Future<void> getUserStores() async {
    final jSessionId = await storage.read(key: 'cookie');
    Response response;
    var baseoptions = BaseOptions(
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'cookie': '$jSessionId',
      },
      baseUrl: "http://10.0.2.2:3003",
    );
    Dio dio = Dio(baseoptions);

    var param = {
      'offset': 0,
      'size': 10,
    };

    try {
      response = await dio.get('/api/users/$uid/stores', data: param);
      if (response.statusCode == 200) {
        print('====================userInfo 200=====================');

        print('[RES BODY] : ${response.data}');
        await storage.write(key: 'userStore', value: jsonEncode(response.data));
        store = Store.fromMap(response.data); // List<Store> 로 받아야할 것 같은 느낌
        // uid = user.uid;
        // storeDTO response
        /* status 400 BAD REQUEST
          body : {
              "code" : 608,  // offset값이 잘못
              "message" : "허용되지 않은 offset 값입니다."
          }

          // 허용되지 않은 size으로 요청할 경우
          status 400 BAD REQUEST
          body : {
              "code" : 609 // size값이 잘못됨
              "message": "허용되지않은 size값입니다."
          } 
        */
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        print("[ERROR] : [$e]");
        // 400 에러의 body
        print('[ERR Body] : ${e.response?.data}');
      }
    }
  }

  // Future<void> getUserInfo() async {
  //   final username = await storage.read(key: 'cookie');
  //   print('username = $username');
  //   Response response;
  //   var baseoptions = BaseOptions(
  //     headers: {
  //       'Content-Type': 'application/json; charset=utf-8',
  //     },
  //     baseUrl: "http://10.0.2.2:3003",
  //   );
  //   Dio dio = Dio(baseoptions);

  //   var param = {
  //     'username': username,
  //   };
  //   print(param);
  //   try {
  //     response = await dio.get('/login', data: param);
  //     if (response.statusCode == 200) {
  //       print('====================userInfo 200=====================');
  //       print('전역변수 : ${MyApp.url}');
  //       print('[RES BODY] : ${response.data}');
  //       user = User.fromMap(response.data);
  //       uid = user.uid;

  //       setState(() {
  //         name = user.person_name;
  //         email = user.email;
  //         state = user.security_state;
  //       });
  //       await storage.write(key: 'userInfo', value: jsonEncode(response.data));
  //       print('유저 보안 레벨 : $state');
  //     }
  //   } on DioException catch (e) {
  //     if (e.response?.statusCode == 400) {
  //       print("[ERROR] : [$e]");
  //       // 400 에러의 body
  //       print('[ERR Body] : ${e.response?.data}');
  //     }
  //   }
  // }

  logoutAction() async {
    await storage.delete(key: 'auto_login');
    await storage.delete(key: 'cookie');
    _pagePopAction();
  }

  _pagePopAction() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  int currentPageIndex = 0;
  int selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_sharp),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue[400],
        iconSize: 37,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      body: SafeArea(
        child: widgetOptions.isEmpty
            ? const CircularProgressIndicator()
            : Container(
                child: widgetOptions.elementAt(selectedIndex),
              ),
      ),
    );
  }
}
