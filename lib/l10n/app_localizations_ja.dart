// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get commonErrorTitle => 'Oops, something went wrong';

  @override
  String get networkError => 'Your network connection is unstable. Check your connection and try again.';

  @override
  String get accessDenied => 'Access denied';
}
