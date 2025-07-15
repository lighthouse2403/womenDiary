import 'package:equatable/equatable.dart';

class BaseState extends Equatable {
  final bool? isLoading;
  final String? error;

  const BaseState({
    this.isLoading,
    this.error
  });

  @override
  List<Object?> get props => [isLoading, error];
}
