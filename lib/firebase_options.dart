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
    apiKey: 'AIzaSyBb7C7ny47e8sk8NkzQtGC3-TAtQZgWta0',
    appId: '1:935305469007:web:f32567f689e32bb01a1e3a',
    messagingSenderId: '935305469007',
    projectId: 'chatbot-62482',
    authDomain: 'chatbot-62482.firebaseapp.com',
    storageBucket: 'chatbot-62482.appspot.com',
    measurementId: 'G-V9Q050Y30K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGQig14tekuJ8nWGvFacbjSRX2KHGMPaM',
    appId: '1:935305469007:android:1244e87661c5fd181a1e3a',
    messagingSenderId: '935305469007',
    projectId: 'chatbot-62482',
    storageBucket: 'chatbot-62482.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB08u24e0LIOtQkzygbkY9_XlTbHOGi8Eg',
    appId: '1:935305469007:ios:b78e09e70bb8b1a41a1e3a',
    messagingSenderId: '935305469007',
    projectId: 'chatbot-62482',
    storageBucket: 'chatbot-62482.appspot.com',
    iosClientId: '935305469007-rh4cg1ibsac4p59fa8grugo2530fi38r.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatBot',
  );
}
