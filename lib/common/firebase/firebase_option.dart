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
    apiKey: 'AIzaSyDy_vl3OTNQZcq9RV1z04nhhNkQpsccqxs',
    appId: '1:842547168180:android:ea902e16cdac74284ea8e1',
    messagingSenderId: '842547168180',
    projectId: 'baby-diary-8c5fb',
    storageBucket: 'baby-diary-8c5fb.appspot.com',
    androidClientId: '842547168180-gimnk7t793bpcpcmhck7uc5cmksu4lbo.apps.googleusercontent.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDy_vl3OTNQZcq9RV1z04nhhNkQpsccqxs',
    appId: '1:842547168180:ios:86b71c5caabae9a2',
    messagingSenderId: '842547168180',
    projectId: 'baby-diary-8c5fb',
    storageBucket: 'baby-diary-8c5fb.appspot.com',
    iosClientId: 'com.googleusercontent.apps.842547168180-gimnk7t793bpcpcmhck7uc5cmksu4lbo',
    iosBundleId: 'baby.diary',
  );
}
