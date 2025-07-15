import 'package:baby_diary/baby_index/baby_weight/bloc/baby_weight_event.dart';
import 'package:baby_diary/baby_index/baby_weight/bloc/baby_weight_state.dart';
import 'package:baby_diary/baby_index/index_model.dart';
import 'package:baby_diary/database/baby_index_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BabyWeightBloc extends Bloc<BabyWeightEvent, BabyWeightState> {
  List<IndexModel> babyWeightList = [];
  IndexModel currentBabyWeight = IndexModel.init(IndexType.weight);

  BabyWeightBloc() : super(const BabyWeightState()) {
    on<InitBabyWeightEvent>(_initCurrentBabyWeight);
    on<LoadBabyWeightEvent>(_loadBabyWeight);
    on<EditTimeEvent>(_editTime);
    on<EditWeightEvent>(_editWeight);
    on<SaveBabyWeightEvent>(_saveBabyWeight);
    on<DeleteBabyWeightEvent>(_deleteBabyWeight);

  }

  Future<void> _initCurrentBabyWeight(InitBabyWeightEvent event, Emitter<BabyWeightState> emit) async {
    try {
      emit(const StartLoadingBabyWeightState());
      currentBabyWeight = event.babyWeight;
      emit(const LoadingBabyWeightSuccessful());
    } catch (error) {
      emit(const LoadingBabyWeightFailState());
    }
  }

  Future<void> _saveBabyWeight(SaveBabyWeightEvent event, Emitter<BabyWeightState> emit) async {
    try {
      emit(const StartSavingBabyWeightState());
      if (currentBabyWeight.value.isEmpty) {
        emit(const SaveBabyWeightFailState());
      }
      await BabyIndexDatabase.insertIndex(currentBabyWeight);
      emit(const SaveBabyWeightSuccessfulState());
    } catch (error) {
      emit(const SaveBabyWeightFailState());
    }
  }

  Future<void> _editTime(EditTimeEvent event, Emitter<BabyWeightState> emit) async {
    try {
      emit(const StartEditBabyWeightState());
      currentBabyWeight.time = event.newTime;
      emit(const LoadingBabyWeightSuccessful());
    } catch (error) {
      emit(const LoadingBabyClothersFail());
    }
  }

  Future<void> _editWeight(EditWeightEvent event, Emitter<BabyWeightState> emit) async {
    try {
      emit(const StartEditBabyWeightState());
      int weight = int.parse(currentBabyWeight.value);

      int newValue = weight + event.weight;
      if (newValue > 0) {
        currentBabyWeight.value = '${newValue}';
      }
      emit(const LoadingBabyWeightSuccessful());
    } catch (error) {
      emit(const LoadingBabyClothersFail());
    }
  }

  Future<void> _loadBabyWeight(LoadBabyWeightEvent event, Emitter<BabyWeightState> emit) async {
    try {
      emit(const StartLoadingBabyWeightState());
      // babyWeightList = await BabyIndexDatabase.getAllWeight();
      emit(const LoadingBabyWeightSuccessful());
    } catch (error) {
      emit(const LoadingBabyWeightFailState());
    }
  }

  Future<void> _deleteBabyWeight(DeleteBabyWeightEvent event, Emitter<BabyWeightState> emit) async {
    emit(const StartDeleteBabyWeightState());
    await BabyIndexDatabase.deleteIndex(event.babyWeightId);
    babyWeightList.removeWhere((element) => element.id == event.babyWeightId);
    emit(const LoadingBabyWeightSuccessful());
  }
}
