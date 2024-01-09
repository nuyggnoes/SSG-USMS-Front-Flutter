import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:usms_app/main.dart';
import 'package:usms_app/screen/notification_screen.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  print("=================앱이 백그라운드에서 실행 중==================");
  print('Title : ${message.notification?.title}');
  print('Body : ${message.notification?.body}');
  print('Payload : ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Android 알림 채널 설정
  final _androidChannel = const AndroidNotificationChannel(
    "high_importance_channel",
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    // importance: Importance.defaultImportance,
    importance: Importance.max,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
  }

  Future initLocalNotifications() async {
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settins = InitializationSettings(android: android, iOS: iOS);

    // FCM을 통해 받은 message를 여기서 Local_notification으로 생성하는 느낌?
    await _localNotifications.initialize(settins,
        onSelectNotification: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload!));
      handleMessage(message);
    });

    // Android 플랫폼에 대한 로컬 알림 설정을 조작하기 위해 Android 전용 플러그인 객체를 가져옴.
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    // Android 알림 채널 생성
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // 앱이 처음 시작될 때, 앱이 종료된 후 다시 시작되었을 때,
    // 앱이 이미 실행 중이지만 백그라운드에서 실행 중일 때 마지막으로 수신된 푸시알림 메시지를 가져옴.
    // 앱이 시작될 때 사용자에게 보여지지 않은 알림 메시지가 있는지를 확인하기 위함.
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // 앱 실행 중이고 사용자가 알림을 탭하여 열었을 때 발생하는 이벤트 처리
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // 백그라운드 상태에서 FCM 메시지를 수신했을 때 발생하는 이벤트 처리
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // FCM에서 메시지를 수신했을 때 발생하는 이벤트 처리 (공통?)

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification == null || android == null) return;
      _localNotifications.show(
        0,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        // 알림과 연결된 데이터를 전달하기 위한 payload(여기서는 FCM메시지를 JSON으로 인코딩하여 전달)
        payload: jsonEncode(message.toMap()),
      );
      print('채널 아이디 : ${_androidChannel.id}');
      print('채널 이름 : ${_androidChannel.name}');
      print(jsonEncode(message.toMap()));
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    // 여기서 받은 토큰을 백엔드 서버로 전송
    // 채널 아이디와 채널 이름도 같이 전송??
    print('My Token : $fcmToken');
    initPushNotifications();
    initLocalNotifications();
  }
}
