import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/action_model.dart';

class ActionTypeEvent extends Equatable {
  const ActionTypeEvent();

  @override
  List<Object?> get props => [];
}

class LoadActionTypeEvent extends ActionTypeEvent {
  const LoadActionTypeEvent();

  @override
  List<Object?> get props => [];
}

/// Action detail
class InitActionTypeDetailEvent extends ActionTypeEvent {
  final ActionTypeModel initialActionType;

  const InitActionTypeDetailEvent(this.initialActionType);

  @override
  List<Object?> get props => [initialActionType];
}

class UpdateActionTypeDetailEvent extends ActionTypeEvent {
  const UpdateActionTypeDetailEvent({required this.id, required this.title, required this.emoji});
  final String title;
  final String emoji;
  final String id;

  @override
  List<Object?> get props => [id, title, emoji];
}

class CreateActionTypeDetailEvent extends ActionTypeEvent {
  const CreateActionTypeDetailEvent(this.title, this.emoji);

  final String title;
  final String emoji;
  @override
  List<Object?> get props => [title, emoji];
}

class DeleteActionTypeEvent extends ActionTypeEvent {
  const DeleteActionTypeEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class UpdateEmojiTypeEvent extends ActionTypeEvent {
  final String emoji;

  const UpdateEmojiTypeEvent(this.emoji);

  @override
  List<Object?> get props => [emoji];
}

class UpdateTitleTypeEvent extends ActionTypeEvent {
  final String title;

  const UpdateTitleTypeEvent(this.title);

  @override
  List<Object?> get props => [title];
}

