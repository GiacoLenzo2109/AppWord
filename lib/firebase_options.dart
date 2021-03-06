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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyABHXClfGnKDoVQ_E8-1RpHCuiCowlK8gQ',
    appId: '1:640994654508:web:16633a632f73125ebb1489',
    messagingSenderId: '640994654508',
    projectId: 'starvation-addword',
    authDomain: 'starvation-addword.firebaseapp.com',
    storageBucket: 'starvation-addword.appspot.com',
    measurementId: 'G-RWE5KZGPMD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlBy5U6ukw8G-ByBKX7bUlQt4Hdnro3eQ',
    appId: '1:640994654508:android:45110879f914e7a9bb1489',
    messagingSenderId: '640994654508',
    projectId: 'starvation-addword',
    storageBucket: 'starvation-addword.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMDwCCD-kMKhKvVg7XdwVMXs9DAKd9DDI',
    appId: '1:640994654508:ios:c2d3f05b7245b14ebb1489',
    messagingSenderId: '640994654508',
    projectId: 'starvation-addword',
    storageBucket: 'starvation-addword.appspot.com',
    iosClientId: '640994654508-vtn8kt7qe2j4dek439ipl7p6v0ac73s6.apps.googleusercontent.com',
    iosBundleId: 'com.starvation.appword.app',
  );
}
