import 'package:baby_diary/baby_index/index_model.dart';
import 'package:equatable/equatable.dart';

class BabyHeightEvent extends Equatable {

  const BabyHeightEvent();

  @override
  List<Object?> get props => [];
}

class InitBabyHeightEvent extends BabyHeightEvent {
  final IndexModel height;
  const InitBabyHeightEvent(this.height);

  @override
  List<Object?> get props => [height];
}

class LoadBabyHeightEvent extends BabyHeightEvent {
  const LoadBabyHeightEvent();

  @override
  List<Object?> get props => [];
}

class DeleteBabyHeightEvent extends BabyHeightEvent {
  const DeleteBabyHeightEvent(this.height);
  final IndexModel height;
  @override
  List<Object?> get props => [height];
}

class SaveBabyHeightEvent extends BabyHeightEvent {
  const SaveBabyHeightEvent(this.height);
  final IndexModel height;

  @override
  List<Object?> get props => [height];
}
