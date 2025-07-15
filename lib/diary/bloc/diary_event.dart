import 'package:women_diary/diary/diary_model.dart';
import 'package:equatable/equatable.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();
}

class LoadDiariesEvent extends DiaryEvent {
  const LoadDiariesEvent();

  @override
  List<Object?> get props => [];
}

class CreateDiaryEvent extends DiaryEvent {
  const CreateDiaryEvent();

  @override
  List<Object?> get props => [];
}

class EditDiaryEvent extends DiaryEvent {
  const EditDiaryEvent();

  @override
  List<Object?> get props => [];
}

class DeleteDiaryEvent extends DiaryEvent {
  const DeleteDiaryEvent(this.diaryId);
  final String diaryId;

  @override
  List<Object?> get props => [diaryId];
}

class AddedPathEvent extends DiaryEvent {
  const AddedPathEvent(this.path);
  final String path;

  @override
  List<Object?> get props => [path];
}

class DeletedPathEvent extends DiaryEvent {
  const DeletedPathEvent(this.path);
  final String path;

  @override
  List<Object?> get props => [path];
}

class InitDiaryEvent extends DiaryEvent {
  const InitDiaryEvent(this.diary);
  final DiaryModel? diary;

  @override
  List<Object?> get props => [diary];
}
