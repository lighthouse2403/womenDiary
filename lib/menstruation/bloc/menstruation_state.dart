import 'package:women_diary/menstruation/menstruation_model.dart';
import 'package:equatable/equatable.dart';

class MenstruationState extends Equatable {
  const MenstruationState();
  @override
  List<Object?> get props => [];
}

class LoadedAllMenstruationState extends MenstruationState {
  const LoadedAllMenstruationState(this.menstruationList);

  final List<MenstruationModel> menstruationList;
  @override
  List<Object?> get props => [menstruationList.length];
}

class MenstruationSavedSuccessfullyState extends MenstruationState {
  const MenstruationSavedSuccessfullyState();

  @override
  List<Object?> get props => [];
}
