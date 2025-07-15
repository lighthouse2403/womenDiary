import 'package:baby_diary/chat/model/thread_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class LoadThreads extends ChatEvent {

  const LoadThreads();

  @override
  List<Object?> get props => [];
}

class LoadComment extends ChatEvent {
  final String threadId;
  const LoadComment(this.threadId);

  @override
  List<Object?> get props => [threadId];
}

class SendComment extends ChatEvent {
  final ThreadModel thread;
  final String comment;
  const SendComment(this.thread, this.comment);

  @override
  List<Object?> get props => [thread, comment];
}
