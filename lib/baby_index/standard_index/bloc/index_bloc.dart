import 'dart:convert';
import 'package:baby_diary/baby_index/standard_index/bloc/index_event.dart';
import 'package:baby_diary/baby_index/standard_index/bloc/index_state.dart';
import 'package:baby_diary/baby_index/standard_index/standard_index_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  List<StandardIndexModel> indexList = [];

  IndexBloc() : super(const IndexState()) {
    on<LoadIndexEvent>(_loadIndex);
  }

  Future<void>_readJson() async {
    final String response = await rootBundle.loadString('assets/data/json/baby_index_detail.json');

    var jsonString = await json.decode(response);
    indexList = (jsonString['index_detail'] as List)
        .map((data) => StandardIndexModel.fromJson(data))
        .toList();

  }

  Future<void>_loadIndex(LoadIndexEvent event, Emitter<IndexState> emit) async {
    try {
      emit(const StartIndexState());
      await _readJson();
      emit(const LoadingSuccessfulIndexState());
    } catch (error) {
      emit(const LoadingFailIndexState());
    }
  }
}
