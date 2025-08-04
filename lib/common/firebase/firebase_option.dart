import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2OYIAsRLW13uf1HlyxDQHKR8-5gPsXcI',
    appId: '1:623638512491:android:4e4bb26116eb37c8a0022e',
    messagingSenderId: '623638512491',
    projectId: 'women-diary-c2f09',
    storageBucket: 'women-diary-c2f09.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCH8WMwhDv4Kkw1wUuhCVQqdxuh8i8L97I',
    appId: '1:623638512491:ios:7a976b2f35060a8ea0022e',
    messagingSenderId: '623638512491',
    projectId: 'women-diary-c2f09',
    storageBucket: 'women-diary-c2f09.firebasestorage.app',
    iosBundleId: 'women.diary',
  );
}
