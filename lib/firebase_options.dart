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
    apiKey: 'AIzaSyCd-Ww1B0i-F9-5qsZqIh6GgAhBj4MfvuQ',
    appId: '1:1000704771785:web:2527bf35679b59c86a2f18',
    messagingSenderId: '1000704771785',
    projectId: 'background-tasks-13133',
    authDomain: 'background-tasks-13133.firebaseapp.com',
    databaseURL: 'https://background-tasks-13133-default-rtdb.firebaseio.com',
    storageBucket: 'background-tasks-13133.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASW8-D6yWD5TSrGP4PWbw-D7G5dn7Nzbw',
    appId: '1:1000704771785:android:d8f1fa6ada22189d6a2f18',
    messagingSenderId: '1000704771785',
    projectId: 'background-tasks-13133',
    databaseURL: 'https://background-tasks-13133-default-rtdb.firebaseio.com',
    storageBucket: 'background-tasks-13133.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7zqDQDgryzsXze2CxU18064ZyHp2bDao',
    appId: '1:1000704771785:ios:5ac097404d6a0e856a2f18',
    messagingSenderId: '1000704771785',
    projectId: 'background-tasks-13133',
    databaseURL: 'https://background-tasks-13133-default-rtdb.firebaseio.com',
    storageBucket: 'background-tasks-13133.firebasestorage.app',
    iosBundleId: 'com.example.carbackgroundtasks',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC7zqDQDgryzsXze2CxU18064ZyHp2bDao',
    appId: '1:1000704771785:ios:5ac097404d6a0e856a2f18',
    messagingSenderId: '1000704771785',
    projectId: 'background-tasks-13133',
    databaseURL: 'https://background-tasks-13133-default-rtdb.firebaseio.com',
    storageBucket: 'background-tasks-13133.firebasestorage.app',
    iosBundleId: 'com.example.carbackgroundtasks',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCd-Ww1B0i-F9-5qsZqIh6GgAhBj4MfvuQ',
    appId: '1:1000704771785:web:7d625431cb84111e6a2f18',
    messagingSenderId: '1000704771785',
    projectId: 'background-tasks-13133',
    authDomain: 'background-tasks-13133.firebaseapp.com',
    databaseURL: 'https://background-tasks-13133-default-rtdb.firebaseio.com',
    storageBucket: 'background-tasks-13133.firebasestorage.app',
  );
}
