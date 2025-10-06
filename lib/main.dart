import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/app_bloc/app_bloc.dart';
import 'package:women_diary/app_bloc/app_event.dart';
import 'package:women_diary/app_bloc/app_state.dart';
import 'package:women_diary/common/admob_handle.dart';
import 'package:women_diary/common/firebase/firebase_option.dart';
import 'package:women_diary/common/firebase/firebase_user.dart';
import 'package:women_diary/common/notification_service.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/l10n_gen/app_localizations.dart';
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

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppBloc()..add(ChangeLanguageEvent(null))),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// ✅ Dùng ValueListenableBuilder để rebuild MaterialApp khi đổi ngôn ngữ
    return BlocBuilder<AppBloc,AppState>(
      builder: (context, state) {
        String languageId = state is LanguageUpdatedState ? state.languageId : 'vi';

        print('State: ${state} -- language: ${languageId}');

        return MaterialApp(
          title: 'Women period tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.pink),
          locale: Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AppStarter(),
        );
      },
    );
  }
}
