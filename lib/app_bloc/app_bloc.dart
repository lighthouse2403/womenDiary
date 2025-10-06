import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/app_bloc/app_event.dart';
import 'package:women_diary/app_bloc/app_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/local_storage_service.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  /// Action list
  DateTime startTime = DateTime.now().subtract(Duration(days: 90));
  DateTime endTime = DateTime.now();
  ActionTypeModel? type;
  List<CycleModel> cycleList = [];

  /// Action detail
  ActionModel actionDetail = ActionModel.init('', DateTime.now(), '', '');
  CycleModel cycle = CycleModel(DateTime.now());

  AppBloc() : super(AppState()) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onChangeLanguage(ChangeLanguageEvent event, Emitter<AppState> emit) async {
    String languageId = await LocalStorageService.getLanguage();
    print('App init language: ${languageId}');

    if (event.languageId != null) {
      languageId = event.languageId!;
    }
    await LocalStorageService.updateLanguage(languageId);
    emit(LanguageUpdatedState(languageId: languageId));
  }

}
