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
    apiKey: 'AIzaSyC7UJJ2xZUFYb3q3bcAYH6FZyuC1TGxIms',
    appId: '1:752649616010:web:d71a59b527b7cadb120b73',
    messagingSenderId: '752649616010',
    projectId: 'fir-test-b4624',
    authDomain: 'fir-test-b4624.firebaseapp.com',
    storageBucket: 'fir-test-b4624.firebasestorage.app',
    measurementId: 'G-K72SF8J1DM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1g0a6q2E71lkQpI_6-L4hycv0QcDseAw',
    appId: '1:752649616010:android:e0431c92080b20c5120b73',
    messagingSenderId: '752649616010',
    projectId: 'fir-test-b4624',
    storageBucket: 'fir-test-b4624.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgl1Loq2PbdmORnVvSxRt7uO9k6Fr1OwQ',
    appId: '1:752649616010:ios:04b28caef1d246c6120b73',
    messagingSenderId: '752649616010',
    projectId: 'fir-test-b4624',
    storageBucket: 'fir-test-b4624.firebasestorage.app',
    iosBundleId: 'com.example.firebaseTest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgl1Loq2PbdmORnVvSxRt7uO9k6Fr1OwQ',
    appId: '1:752649616010:ios:04b28caef1d246c6120b73',
    messagingSenderId: '752649616010',
    projectId: 'fir-test-b4624',
    storageBucket: 'fir-test-b4624.firebasestorage.app',
    iosBundleId: 'com.example.firebaseTest',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC7UJJ2xZUFYb3q3bcAYH6FZyuC1TGxIms',
    appId: '1:752649616010:web:6f9a81a4b3a14a0d120b73',
    messagingSenderId: '752649616010',
    projectId: 'fir-test-b4624',
    authDomain: 'fir-test-b4624.firebaseapp.com',
    storageBucket: 'fir-test-b4624.firebasestorage.app',
    measurementId: 'G-ZLZGMLM7T3',
  );
}
