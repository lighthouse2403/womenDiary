import 'package:baby_diary/common/firebase/firebase_option.dart';
import 'package:baby_diary/common/firebase/firebase_user.dart';
import 'package:baby_diary/l10n/app_localizations.dart';
import 'package:baby_diary/routes/route_name.dart';
import 'package:baby_diary/routes/routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: 'BabyDiary',options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseUser.instance.addUser();

  runApp(const BabyDiary());
}

class BabyDiary extends StatelessWidget {
  const BabyDiary({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  void saveUserLog() async {
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        themeMode: ThemeMode.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: Routes.generateRouter(RoutesName.diaries)
    );
  }
}
