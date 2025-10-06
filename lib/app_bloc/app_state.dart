import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class LanguageUpdatedState extends AppState {
  final String languageId;
  const LanguageUpdatedState({required this.languageId});

  @override
  List<Object?> get props => [languageId];
}