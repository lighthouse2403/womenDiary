import 'package:baby_diary/music/model/music_model.dart';
import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();
}

class PlayMusicEvent extends MusicEvent {
  MusicModel music;
  PlayMusicEvent(this.music);

  @override
  List<Object?> get props => [];
}

class PauseMusicEvent extends MusicEvent {
  MusicModel music;
  PauseMusicEvent(this.music);

  @override
  List<Object?> get props => [];
}