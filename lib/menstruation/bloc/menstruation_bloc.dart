import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/menstruation/bloc/menstruation_event.dart';
import 'package:women_diary/menstruation/bloc/menstruation_state.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';

class MenstruationBloc extends Bloc<MenstruationEvent, MenstruationState> {
  List<MenstruationModel> menstruationList = [];

  MenstruationBloc() : super(const MenstruationState()) {
    on<LoadAllMenstruationEvent>(_loadAllMenstruation);
    on<DeleteMenstruationEvent>(_deleteMenstruation);

  }

  Future<void> _loadAllMenstruation(LoadAllMenstruationEvent event, Emitter<MenstruationState> emit) async {
    try {
      menstruationList = await DatabaseHandler.getAllMenstruation();
      emit(LoadedAllMenstruationState(menstruationList));
    } catch (error) {
    }
  }

  Future<void> _deleteMenstruation(DeleteMenstruationEvent event, Emitter<MenstruationState> emit) async {
    try {
      await DatabaseHandler.deleteMenstruation(event.startTime.millisecondsSinceEpoch, event.endTime.millisecondsSinceEpoch);
      menstruationList.removeWhere((e) => e.startTime.millisecondsSinceEpoch == event.startTime.millisecondsSinceEpoch && e.endTime.millisecondsSinceEpoch == event.endTime.millisecondsSinceEpoch);
      print('menstruationList length: ${menstruationList.length}');
      emit(LoadedAllMenstruationState(menstruationList));
    } catch (error) {
    }
  }
}
