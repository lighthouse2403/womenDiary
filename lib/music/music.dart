import 'package:audio_session/audio_session.dart';
import 'package:baby_diary/common/base/base_app_bar.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/common/constants/constants.dart';
import 'package:baby_diary/common/extension/text_extension.dart';
import 'package:baby_diary/music/audio_handler.dart';
import 'package:baby_diary/music/play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class Audios extends BaseStatefulWidget {
  const Audios({super.key});
  @override
  State<Audios> createState() => _AudiosState();
}

class _AudiosState extends BaseStatefulState<Audios> {
  static int _nextMediaId = 0;
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playlist;
  Uri bannerUri = Uri.parse('assets/images/cute_little_baby.jpg');

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initPlaylist();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  _initPlaylist() {
    _playlist = ConcatenatingAudioSource(
        children: [
          ClippingAudioSource(
            start: const Duration(seconds: 60),
            end: const Duration(seconds: 90),
            child: AudioSource.uri(Uri.parse('${Constants.audioPath}pregnancy_sound_1.mp3')),
            tag: MediaItem(
              id: '${_nextMediaId++}',
              album: "Nhạc không lời",
              title: "Bản nhạc số 1",
              artUri: bannerUri,
            ),
          ),
          AudioSource.uri(Uri.parse('${Constants.audioPath}pregnancy_sound_2.mp3'),
            tag: MediaItem(
              id: '${_nextMediaId++}',
              album: "Nhạc không lời",
              title: "Bản nhạc số 2",
              artUri: bannerUri,
            ),
          ),
          AudioSource.uri(Uri.parse('${Constants.audioPath}pregnancy_sound_3.mp3'),
            tag: MediaItem(
              id: '${_nextMediaId++}',
              album: "Nhạc không lời",
              title: "Bản nhạc số 3",
              artUri: bannerUri,
            ),
          ),
          AudioSource.uri(Uri.parse('${Constants.audioPath}pregnancy_sound_4.mp3'),
            tag: MediaItem(
              id: '${_nextMediaId++}',
              album: "Nhạc không lời",
              title: "Bản nhạc số 4",
              artUri: bannerUri,
            ),
          )
        ]
    );
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
        });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e, _) {

    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  PreferredSizeWidget? buildAppBar() {
    return BaseAppBar(
        title: 'Âm nhạc',
        hasBack: true
    );
  }

  @override
  Widget? buildBody() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(metadata.artUri.toString(), fit: BoxFit.fitWidth),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              ControlButtons(_player),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: (newPosition) {
                      _player.seek(newPosition);
                    },
                  );
                },
              ),
              Row(
                children: [
                  StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.grey),
                        Icon(Icons.repeat, color: Colors.orange),
                        Icon(Icons.repeat_one, color: Colors.orange),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          _player.setLoopMode(cycleModes[
                          (cycleModes.indexOf(loopMode) + 1) %
                              cycleModes.length]);
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: const Text("Danh sách").w600().text16().mainColor().center(),
                  ),
                  StreamBuilder<bool>(
                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? const Icon(Icons.shuffle, color: Colors.orange)
                            : const Icon(Icons.shuffle, color: Colors.grey),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await _player.shuffle();
                          }
                          await _player.setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder<SequenceState?>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final sequence = state?.sequence ?? [];
                      return ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) newIndex--;
                          _playlist.move(oldIndex, newIndex);
                        },
                        children: [
                          for (var i = 0; i < sequence.length; i++)
                            Dismissible(
                              key: ValueKey(sequence[i]),
                              background: Container(
                                color: Colors.redAccent,
                                alignment: Alignment.centerRight,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              onDismissed: (dismissDirection) {
                                _playlist.removeAt(i);
                              },
                              child: Material(
                                color: i == state!.currentIndex
                                    ? Colors.grey.shade300
                                    : null,
                                child: ListTile(
                                  title: Text(sequence[i].tag.title as String),
                                  onTap: () {
                                    _player.seek(Duration.zero, index: i);
                                  },
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}