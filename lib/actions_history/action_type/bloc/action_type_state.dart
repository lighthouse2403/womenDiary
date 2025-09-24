import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/action_model.dart';

class ActionTypeState extends Equatable {
  const ActionTypeState();

  @override
  List<Object?> get props => [];
}

class ActionTypeLoadedState extends ActionTypeState {
  final List<ActionTypeModel> actionTypes;

  const ActionTypeLoadedState({required this.actionTypes});

  @override
  List<Object?> get props => [actionTypes.length, DateTime.now().microsecondsSinceEpoch];
}

class ActionTypeLoadedErrorState extends ActionTypeState {
  final String message;

  const ActionTypeLoadedErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Action detail
class ActionTypeUpdatedState extends ActionTypeState {
  final ActionTypeModel initialActionType;

  const ActionTypeUpdatedState(this.initialActionType);

  @override
  List<Object?> get props => [initialActionType];
}

class SaveButtonState extends ActionTypeState {
  const SaveButtonState(this.isEnable);

  final bool isEnable;
  @override
  List<Object?> get props => [isEnable];
}

class EmojiUpdatedState extends ActionTypeState {
  final String emoji;

  const EmojiUpdatedState(this.emoji);

  @override
  List<Object?> get props => [emoji];
}

class TitleUpdatedState extends ActionTypeState {
  final String title;

  const TitleUpdatedState(this.title);

  @override
  List<Object?> get props => [title];
}

class ActionTypeSavedSuccessfullyState extends ActionTypeState {
  const ActionTypeSavedSuccessfullyState();

  @override
  List<Object?> get props => [];
}

class ActionTypeDeletedState extends ActionTypeState {
  const ActionTypeDeletedState();

  @override
  List<Object?> get props => [];
}