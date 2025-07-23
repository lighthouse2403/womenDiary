import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/menstruation/bloc/menstruation_event.dart';
import 'package:women_diary/menstruation/bloc/menstruation_state.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';

class MenstruationBloc extends Bloc<MenstruationEvent, MenstruationState> {
  List<MenstruationModel> menstruationList = [];

  MenstruationBloc() : super(const MenstruationState()) {
    on<LoadAllMenstruationEvent>(_loadAllMenstruation);
  }

  Future<void> _loadAllMenstruation(LoadAllMenstruationEvent event, Emitter<MenstruationState> emit) async {
    try {
      menstruationList = await DatabaseHandler.getAllMenstruation();
    } catch (error) {
    }
  }
}
