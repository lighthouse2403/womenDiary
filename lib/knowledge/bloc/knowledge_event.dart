import 'package:baby_diary/common/constants/constants.dart';
import 'package:equatable/equatable.dart';

abstract class KnowledgeEvent extends Equatable {
  const KnowledgeEvent();
}

class LoadKnowledgeEvent extends KnowledgeEvent {
  const LoadKnowledgeEvent(this.type);
  final KnowLedgeType type;
  @override
  List<Object?> get props => [type];
}
