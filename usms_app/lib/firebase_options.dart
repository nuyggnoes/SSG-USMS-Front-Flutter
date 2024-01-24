// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC8booKlTTYMMcjQYLUFWtvLQZR14ZpBkY',
    appId: '1:887270635378:web:fb99dce674a171cfb44feb',
    messagingSenderId: '887270635378',
    projectId: 'fcmapp-5deff',
    authDomain: 'fcmapp-5deff.firebaseapp.com',
    storageBucket: 'fcmapp-5deff.appspot.com',
    measurementId: 'G-SNTY4R1EGV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvZCZ_JWxWdnDeUhoYxzntW1Jd2pQu2uk',
    appId: '1:887270635378:android:86173d135827f73fb44feb',
    messagingSenderId: '887270635378',
    projectId: 'fcmapp-5deff',
    storageBucket: 'fcmapp-5deff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgOI8GYX8RvB6wqzw0tOhoFWf6SWgpSjU',
    appId: '1:887270635378:ios:fe524e05f6633f5cb44feb',
    messagingSenderId: '887270635378',
    projectId: 'fcmapp-5deff',
    storageBucket: 'fcmapp-5deff.appspot.com',
    iosBundleId: 'com.example.usmsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAgOI8GYX8RvB6wqzw0tOhoFWf6SWgpSjU',
    appId: '1:887270635378:ios:50c79f53b169dd28b44feb',
    messagingSenderId: '887270635378',
    projectId: 'fcmapp-5deff',
    storageBucket: 'fcmapp-5deff.appspot.com',
    iosBundleId: 'com.example.usmsApp.RunnerTests',
  );
}