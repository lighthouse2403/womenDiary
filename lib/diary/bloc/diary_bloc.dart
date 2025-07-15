import 'package:baby_diary/database/mother_database.dart';
import 'package:baby_diary/diary/diary_model.dart';
import 'package:bloc/bloc.dart';
import 'package:baby_diary/diary/bloc/diary_event.dart';
import 'package:baby_diary/diary/bloc/diary_state.dart';


class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  List<DiaryModel> diaries = [];
  DiaryModel? currentDiary;

  DiaryBloc() : super(const DiaryState()) {
    on<LoadDiariesEvent>(_loadDiaries);
    on<DeleteDiaryEvent>(_deleteDiary);
  }

  Future<void> _loadDiaries(LoadDiariesEvent event, Emitter<DiaryState> emit) async {
    try {
      emit(const StartLoadingState());
      diaries = await MotherDatabase.getDiaries();
      emit(const LoadingSuccessfulState());
    } catch (error) {
      emit(const LoadingFailState());
    }
  }

  Future<void> _deleteDiary(DeleteDiaryEvent event, Emitter<DiaryState> emit) async {
    emit(const StartDeleteDiary());
    await MotherDatabase.deleteAllDiary(event.diaryId);
    diaries.removeWhere((element) => element.id == event.diaryId);
    emit(const LoadingSuccessfulState());
  }
}
