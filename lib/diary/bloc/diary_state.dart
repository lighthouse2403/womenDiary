import 'package:equatable/equatable.dart';

class DiaryState extends Equatable {
  final bool? isSubmitting;

  const DiaryState({this.isSubmitting,});

  @override
  List<Object?> get props => [isSubmitting];
}

class StartLoadingState extends DiaryState {

  const StartLoadingState();

  @override
  List<Object?> get props => [];
}

class LoadingSuccessfulState extends DiaryState {

  const LoadingSuccessfulState();

  @override
  List<Object?> get props => [];
}

class LoadingFailState extends DiaryState {

  const LoadingFailState();

  @override
  List<Object?> get props => [];
}

class StartInitDiary extends DiaryState {

  const StartInitDiary();

  @override
  List<Object?> get props => [];
}

class InitDiarySuccessful extends DiaryState {

  const InitDiarySuccessful();

  @override
  List<Object?> get props => [];
}

class SaveDiarySuccessful extends DiaryState {

  const SaveDiarySuccessful();

  @override
  List<Object?> get props => [];
}

class SaveDiaryFail extends DiaryState {

  const SaveDiaryFail();

  @override
  List<Object?> get props => [];
}


class StartAddingPath extends DiaryState {

  const StartAddingPath();

  @override
  List<Object?> get props => [];
}

class AddingPathSuccessful extends DiaryState {

  const AddingPathSuccessful();

  @override
  List<Object?> get props => [];
}

class StartDeletingPath extends DiaryState {

  const StartDeletingPath();

  @override
  List<Object?> get props => [];
}

class DeletingPathSuccessful extends DiaryState {

  const DeletingPathSuccessful();

  @override
  List<Object?> get props => [];
}

class StartDeleteDiary extends DiaryState {

  const StartDeleteDiary();

  @override
  List<Object?> get props => [];
}
