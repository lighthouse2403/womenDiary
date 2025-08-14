import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/common/firebase/firebase_option.dart';
import 'package:women_diary/common/firebase/firebase_user.dart';
import 'package:women_diary/common/notification_service.dart';
import 'package:women_diary/database/local_storage_service.dart';

import 'app_starter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await Firebase.initializeApp(
    name: 'WomenDiary',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseUser.instance.addUser();
  await LocalStorageService.init();

  runApp(const AppStarter());
}
