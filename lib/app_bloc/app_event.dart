import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/action_model.dart';

class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class ChangeLanguageEvent extends AppEvent {
  const ChangeLanguageEvent(this.languageId);
  final String? languageId;

  @override
  List<Object?> get props => [languageId];
}