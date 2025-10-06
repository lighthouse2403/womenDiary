import 'package:flutter/material.dart';
import 'package:women_diary/l10n/app_localizations.dart';

extension ContextExt on BuildContext {
  AppLocalizations get language => AppLocalizations.of(this)!;

  ThemeData get appThemes => Theme.of(this);
}