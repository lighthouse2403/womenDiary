import 'package:equatable/equatable.dart';

class KnowledgeState extends Equatable {
  final bool? isSubmitting;

  const KnowledgeState({this.isSubmitting,});

  @override
  List<Object?> get props => [isSubmitting];
}

class StartLoadingState extends KnowledgeState {

  const StartLoadingState();

  @override
  List<Object?> get props => [];
}

class LoadingKnowledgeSuccessfullyState extends KnowledgeState {

  const LoadingKnowledgeSuccessfullyState();

  @override
  List<Object?> get props => [];
}

class LoadingKnowledgeFailState extends KnowledgeState {

  const LoadingKnowledgeFailState();

  @override
  List<Object?> get props => [];
}
