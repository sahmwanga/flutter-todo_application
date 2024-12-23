// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDPGweUKZZVwjGq8IR0-mxfAqoXdQbkB0c',
    appId: '1:910701403127:web:03cc6e697891717f0decf2',
    messagingSenderId: '910701403127',
    projectId: 'flutter-shop-67f72',
    authDomain: 'flutter-shop-67f72.firebaseapp.com',
    databaseURL: 'https://flutter-shop-67f72-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-shop-67f72.firebasestorage.app',
    measurementId: 'G-E3NTR99ZD9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkqfSJwK1uLhTAjQiObPwB0AKkmalhqmk',
    appId: '1:910701403127:android:e0c5f8ee716c957e0decf2',
    messagingSenderId: '910701403127',
    projectId: 'flutter-shop-67f72',
    databaseURL: 'https://flutter-shop-67f72-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-shop-67f72.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPFpSP7kp8oxcNET82Uy363hAhUTIJbgw',
    appId: '1:910701403127:ios:bc7ddcb87dcd12e60decf2',
    messagingSenderId: '910701403127',
    projectId: 'flutter-shop-67f72',
    databaseURL: 'https://flutter-shop-67f72-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-shop-67f72.firebasestorage.app',
    iosBundleId: 'com.example.todoApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBPFpSP7kp8oxcNET82Uy363hAhUTIJbgw',
    appId: '1:910701403127:ios:bc7ddcb87dcd12e60decf2',
    messagingSenderId: '910701403127',
    projectId: 'flutter-shop-67f72',
    databaseURL: 'https://flutter-shop-67f72-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-shop-67f72.firebasestorage.app',
    iosBundleId: 'com.example.todoApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDPGweUKZZVwjGq8IR0-mxfAqoXdQbkB0c',
    appId: '1:910701403127:web:22554651873cc8030decf2',
    messagingSenderId: '910701403127',
    projectId: 'flutter-shop-67f72',
    authDomain: 'flutter-shop-67f72.firebaseapp.com',
    databaseURL: 'https://flutter-shop-67f72-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-shop-67f72.firebasestorage.app',
    measurementId: 'G-GTQZ753TEP',
  );

}