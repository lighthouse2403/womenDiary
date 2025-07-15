import 'package:baby_diary/chat/model/comment_model.dart';
import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final bool? isSubmitting;

  const ChatState({this.isSubmitting,});

  @override
  List<Object?> get props => [isSubmitting];
}

class LoadingState extends ChatState {

  const LoadingState();

  @override
  List<Object?> get props => [];
}

class LoadingSuccessfulState extends ChatState {

  const LoadingSuccessfulState();

  @override
  List<Object?> get props => [];
}

class LoadingThreadFailState extends ChatState {

  const LoadingThreadFailState();

  @override
  List<Object?> get props => [];
}

/// Chat detail
class LoadingCommentsSuccessfulState extends ChatState {
  List<CommentModel> comments;
  LoadingCommentsSuccessfulState(this.comments);

  @override
  List<Object?> get props => [comments];
}

class SendCommentSuccessful extends ChatState {
  const SendCommentSuccessful();

  @override
  List<Object?> get props => [];
}
