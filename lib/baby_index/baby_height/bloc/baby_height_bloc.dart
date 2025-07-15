import 'package:baby_diary/baby_index/baby_height/bloc/baby_height_event.dart';
import 'package:baby_diary/baby_index/baby_height/bloc/baby_height_state.dart';
import 'package:baby_diary/baby_index/index_model.dart';
import 'package:baby_diary/database/baby_index_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BabyHeightBloc extends Bloc<BabyHeightEvent, BabyHeightState> {
  List<IndexModel> heightList =[];
  IndexModel currentBabyHeight = IndexModel.init(IndexType.height);

  BabyHeightBloc() : super(const BabyHeightState()) {
    on<SaveBabyHeightEvent>(_saveBabyHeight);
    on<DeleteBabyHeightEvent>(_deleteBabyHeight);
    on<InitBabyHeightEvent>(_initBabyHeight);
  }

  Future<void> _initBabyHeight(InitBabyHeightEvent event, Emitter emit) async {
    try {
      currentBabyHeight = event.height;
    } catch (error) {
    }
  }

  void _saveBabyHeight(SaveBabyHeightEvent event, Emitter emit) async {
    currentBabyHeight = event.height;
    BabyIndexDatabase.insertIndex(currentBabyHeight);
  }

  void _deleteBabyHeight(DeleteBabyHeightEvent event, Emitter emit) async {
    BabyIndexDatabase.deleteIndex(currentBabyHeight.id);
  }
}
