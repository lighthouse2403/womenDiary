import 'package:equatable/equatable.dart';

class MusicState extends Equatable {
  final bool? isSubmitting;

  const MusicState({this.isSubmitting,});

  @override
  List<Object?> get props => [];
}

class StartPlayingState extends MusicState {
  const StartPlayingState();

  @override
  List<Object?> get props => [];
}

class PlayingState extends MusicState {
  const PlayingState();

  @override
  List<Object?> get props => [];
}

class PlayingFailState extends MusicState {
  const PlayingFailState();

  @override
  List<Object?> get props => [];
}

class StartPauseState extends MusicState {

  const StartPauseState();
  @override
  List<Object?> get props => [];
}

class PauseMusicState extends MusicState {

  const PauseMusicState();

  @override
  List<Object?> get props => [];
}

class PauseFailState extends MusicState {
  const PauseFailState();

  @override
  List<Object?> get props => [];
}