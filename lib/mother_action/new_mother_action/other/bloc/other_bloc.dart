import 'package:baby_diary/database/mother_database.dart';
import 'package:baby_diary/mother_action/new_mother_action/other/bloc/other_event.dart';
import 'package:baby_diary/mother_action/new_mother_action/other/bloc/other_state.dart';
import 'package:baby_diary/mother_action/new_mother_action/other/other_model.dart';
import 'package:bloc/src/bloc.dart';

class OtherBloc extends Bloc<OtherEvent, OtherState> {
  List<OtherModel> otherList =[];
  OtherModel otherDetail = OtherModel.init();

  OtherBloc() : super(const OtherState()) {
    on<SaveOtherRecordEvent>(_saveOtherRecord);
    on<DeleteOtherRecordEvent>(_deleteOtherRecord);
  }

  Future<void> _saveOtherRecord(SaveOtherRecordEvent event, Emitter emit) async {
    MotherDatabase.insertOther(otherDetail);
  }

  Future<void> _deleteOtherRecord(DeleteOtherRecordEvent event, Emitter emit) async {
  }
}
