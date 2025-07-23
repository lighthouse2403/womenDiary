import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:equatable/equatable.dart';

class MenstruationState extends Equatable {
  const MenstruationState();
  @override
  List<Object?> get props => [];
}

class LoadedAllMenstruationState extends MenstruationState {
  final List<MenstruationModel> menstruationList;
  const LoadedAllMenstruationState({ required this.menstruationList });
  @override
  List<Object?> get props => [menstruationList.length];
}
