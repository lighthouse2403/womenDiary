import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/common/admob_handle.dart';
import 'package:women_diary/common/firebase/firebase_option.dart';
import 'package:women_diary/common/firebase/firebase_user.dart';
import 'package:women_diary/common/notification_service.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/l10n/app_localizations.dart';

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
  await AdsHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final languageId = await LocalStorageService.getLanguage();
    setState(() {
      _locale = Locale(languageId);
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    LocalStorageService.updateLanguage(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Women period tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppStarter(),
    );
  }
}

