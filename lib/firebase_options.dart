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
    apiKey: 'AIzaSyDk9OtgFVSGOD1EZ4tBAQv0MXNtpAAQ9yo',
    appId: '1:744668372957:web:89076545a58dbec6946034',
    messagingSenderId: '744668372957',
    projectId: 'hajjapp-3da80',
    authDomain: 'hajjapp-3da80.firebaseapp.com',
    databaseURL: 'https://hajjapp-3da80-default-rtdb.firebaseio.com',
    storageBucket: 'hajjapp-3da80.appspot.com',
    measurementId: 'G-6N78V6QCZF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjsLBd3doN2gX4US2PwwgcJAwwRA3Y6XI',
    appId: '1:744668372957:android:3082b97fa360358d946034',
    messagingSenderId: '744668372957',
    projectId: 'hajjapp-3da80',
    databaseURL: 'https://hajjapp-3da80-default-rtdb.firebaseio.com',
    storageBucket: 'hajjapp-3da80.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjgAkt2vjYQ5hLAXb58h8oWLFYu3z1oZw',
    appId: '1:744668372957:ios:1269f0b0069c25c6946034',
    messagingSenderId: '744668372957',
    projectId: 'hajjapp-3da80',
    databaseURL: 'https://hajjapp-3da80-default-rtdb.firebaseio.com',
    storageBucket: 'hajjapp-3da80.appspot.com',
    iosBundleId: 'com.example.hajjApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjgAkt2vjYQ5hLAXb58h8oWLFYu3z1oZw',
    appId: '1:744668372957:ios:094544dee78c5d72946034',
    messagingSenderId: '744668372957',
    projectId: 'hajjapp-3da80',
    databaseURL: 'https://hajjapp-3da80-default-rtdb.firebaseio.com',
    storageBucket: 'hajjapp-3da80.appspot.com',
    iosClientId: '744668372957-stdich7h8pldvb3bfqq059c3vhr3bhbn.apps.googleusercontent.com',
    iosBundleId: 'com.example.hajiApp.RunnerTests',
  );
}
