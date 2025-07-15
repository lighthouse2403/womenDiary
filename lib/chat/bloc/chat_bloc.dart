import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/chat/bloc/chat_event.dart';
import 'package:women_diary/chat/bloc/chat_state.dart';
import 'package:women_diary/chat/model/comment_model.dart';
import 'package:women_diary/chat/model/thread_model.dart';
import 'package:women_diary/common/firebase/firebase_chat.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  int paging = 100;
  List<ThreadModel> threads = [];

  ChatBloc() : super(const ChatState()) {
    on<LoadThreads>(_loadThreads);
    on<LoadComment>(_loadComment);
    on<SendComment>(_sendComment);

  }

  Future<void> _loadThreads(ChatEvent event, Emitter<ChatState> emit) async {
    try {
      emit(const LoadingState());
      threads = await FirebaseChat.instance.loadThread();
      emit(const LoadingSuccessfulState());
    } catch (error) {
      emit(const LoadingThreadFailState());
    }
  }

  Future<void> _loadComment(LoadComment event, Emitter<ChatState> emit) async {
    try {
      emit(const LoadingState());
      List<CommentModel> comments = await FirebaseChat.instance.loadComment(event.threadId);
      emit(LoadingCommentsSuccessfulState(comments));
    } catch (error) {
      emit(const LoadingThreadFailState());
    }
  }

  Future<void> _sendComment(SendComment event, Emitter<ChatState> emit) async {
    try {
      emit(const LoadingState());
      await FirebaseChat.instance.addNewComment(event.thread, event.comment);
      emit(const SendCommentSuccessful());
    } catch (error) {
      emit(const LoadingThreadFailState());
    }
  }
}
