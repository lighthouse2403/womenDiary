import 'package:baby_diary/music/bloc/music_event.dart';
import 'package:baby_diary/music/bloc/music_state.dart';
import 'package:baby_diary/music/model/music_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {

  List<MusicModel> musics = [];
  MusicModel? currentMusic;

  MusicBloc() : super(const MusicState()) {
    on<PlayMusicEvent>(_playMusic);
    on<PauseMusicEvent>(_pauseMusic);
  }

  Future<void> _playMusic(PlayMusicEvent event, Emitter<MusicState> emit) async {
    try {
      emit(const PlayingState());
    } catch (error) {
      emit(const PlayingFailState());
    }
  }

  Future<void> _pauseMusic(PauseMusicEvent event, Emitter<MusicState> emit) async {
    try {
      emit(const PauseMusicState());
    } catch (error) {
      emit(const PauseFailState());
    }
  }
}
