 import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/knowledge/bloc/knowledge_event.dart';
import 'package:baby_diary/knowledge/bloc/knowledge_state.dart';
import 'package:bloc/bloc.dart';
import 'package:baby_diary/database/data_handler.dart';

class KnowledgeBloc extends Bloc<KnowledgeEvent, KnowledgeState> {
  List<BabyModel> babyList = [];
  BabyModel? currentBaby;

  KnowledgeBloc() : super(const KnowledgeState()) {
    on<LoadKnowledgeEvent>(_loadKnowledge);
  }

  Future<void> _loadKnowledge(LoadKnowledgeEvent event, Emitter<KnowledgeState> emit) async {
    try {
      emit(const StartLoadingState());
      babyList = await DatabaseHandler.getAllBaby();
      currentBaby = babyList.firstOrNull;
      emit(const LoadingKnowledgeSuccessfullyState());
    } catch (error) {
      emit(const LoadingKnowledgeFailState());
    }
  }
}
