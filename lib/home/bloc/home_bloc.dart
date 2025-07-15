import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/period/red_date.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<RedDateModel> redDate =[];

  HomeBloc() : super(const HomeState()) {
    on<LoadTodayActionEvent>(_loadTodayActions);
  }


  Future<void> _loadTodayActions(LoadTodayActionEvent event, Emitter emit) async {
    redDate = await DatabaseHandler.getAllRedDate();
    emit(LoadedRedDateState(redDate));
  }
}
