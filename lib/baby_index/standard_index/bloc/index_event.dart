import 'package:equatable/equatable.dart';

abstract class IndexEvent extends Equatable {
  const IndexEvent();
}

class LoadIndexEvent extends IndexEvent {
  const LoadIndexEvent();

  @override
  List<Object?> get props => [];
}
