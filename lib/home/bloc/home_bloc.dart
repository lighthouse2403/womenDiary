import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/database/baby_action_database.dart';
import 'package:baby_diary/database/data_handler.dart';
import 'package:baby_diary/home/bloc/home_event.dart';
import 'package:baby_diary/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<BabyActionModel> babyActions =[];
  BabyModel baby = BabyModel.init();
  
  HomeBloc() : super(const HomeState()) {
    on<LoadBabyInformationEvent>(_loadBabyInformation);
    on<LoadTodayActionEvent>(_loadTodayActions);
  }

  /// Bath detail
  Future<void> _loadBabyInformation(LoadBabyInformationEvent event, Emitter emit) async {
    baby = await DatabaseHandler.getSelectedBaby();
    emit(LoadedSelectedBabyState(baby));
  }

  Future<void> _loadTodayActions(LoadTodayActionEvent event, Emitter emit) async {
    babyActions = await BabyActionsDatabase.getActionsOnDate(DateTime.now());
    emit(LoadedBabyActionState(babyActions));
  }
}
