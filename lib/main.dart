import 'package:women_diary/common/firebase/firebase_option.dart';
import 'package:women_diary/common/firebase/firebase_user.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/l10n/app_localizations.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_starter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'WomenDiary',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseUser.instance.addUser();
  await LocalStorageService.init();

  final useBiometric = await LocalStorageService.checkUsingBiometric();

  runApp(AppStarter(useBiometric: useBiometric));
}
