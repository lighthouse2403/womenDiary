import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/base/bloc/base_event.dart';
import 'package:women_diary/common/base/bloc/base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {

  BaseBloc() : super(BaseState()) {
  }
}
