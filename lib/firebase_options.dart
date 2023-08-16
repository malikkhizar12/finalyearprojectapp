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
    apiKey: 'AIzaSyB1yhrMGecnzLGl0fEsvGA-ikvpF2ocbhY',
    appId: '1:860210445225:web:a7cb82d08352ebdcd162b8',
    messagingSenderId: '860210445225',
    projectId: 'course-guide-61927',
    authDomain: 'course-guide-61927.firebaseapp.com',
    storageBucket: 'course-guide-61927.appspot.com',
    measurementId: 'G-DRNY0ZZD6S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdFaFpeH-CQ9eQjgU5MhPVcX_lNRE7V5E',
    appId: '1:860210445225:android:a82d6566056b6c04d162b8',
    messagingSenderId: '860210445225',
    projectId: 'course-guide-61927',
    storageBucket: 'course-guide-61927.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6cd3Ic_Z8Ev42PduSZmjKQYpFEgUnJ6s',
    appId: '1:860210445225:ios:16e176e0150dfecbd162b8',
    messagingSenderId: '860210445225',
    projectId: 'course-guide-61927',
    storageBucket: 'course-guide-61927.appspot.com',
    androidClientId: '860210445225-g6o1te24gcs1mnctbn9hdt68uar48tdu.apps.googleusercontent.com',
    iosClientId: '860210445225-jg1dpu3k6t1ifa3tfv1noj14aq0fhm47.apps.googleusercontent.com',
    iosBundleId: 'com.example.courseGuideApp',
  );
}
