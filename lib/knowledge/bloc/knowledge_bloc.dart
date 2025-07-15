import 'package:women_diary/knowledge/bloc/knowledge_event.dart';
import 'package:women_diary/knowledge/bloc/knowledge_state.dart';
import 'package:bloc/bloc.dart';

class KnowledgeBloc extends Bloc<KnowledgeEvent, KnowledgeState> {

  KnowledgeBloc() : super(const KnowledgeState()) {
    on<LoadKnowledgeEvent>(_loadKnowledge);
  }

  Future<void> _loadKnowledge(LoadKnowledgeEvent event, Emitter<KnowledgeState> emit) async {
    try {
      emit(const StartLoadingState());
      emit(const LoadingKnowledgeSuccessfullyState());
    } catch (error) {
      emit(const LoadingKnowledgeFailState());
    }
  }
}
