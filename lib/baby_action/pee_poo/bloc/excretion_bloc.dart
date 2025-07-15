import 'package:baby_diary/baby_action/pee_poo/bloc/excretion_event.dart';
import 'package:baby_diary/baby_action/pee_poo/bloc/excretion_state.dart';
import 'package:baby_diary/baby_action/pee_poo/excretion_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExcretionBloc extends Bloc<ExcretionEvent, ExcretionState> {
  List<ExcretionModel> excretionList =[];
  ExcretionModel currentExcretion = ExcretionModel.init();

  ExcretionBloc() : super(const ExcretionState()) {
    on<ChangeBabyEvent>(_changBaby);

  }

  /// Bottle Milk detail
  Future<void> _changBaby(ChangeBabyEvent event, Emitter emit) async {
    currentExcretion.babyId = event.baby.babyId;
  }
}
