import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import '/models/player_state_model.dart';
import 'firebase_controller.dart';

final playerManagerProvider = StateNotifierProvider.autoDispose
    .family<PlayerController, MyPlayerState, String>(
  (ref, url) => PlayerController(url, ref),
);

final currentlyPlayingIdProvider = StateProvider<String?>((ref) => null);

final currentSongProvider = StateProvider<SongModel?>((ref) {
  return;
});

class PlayerController extends StateNotifier<MyPlayerState> {
  final String urlLink;
  final Ref ref;
  late final AudioPlayer _audioPlayer;

  PlayerController(this.urlLink, this.ref) : super(MyPlayerState.initial()) {
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(urlLink);

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        state = state.copyWith(songState: SongState.loading);
      } else if (!isPlaying) {
        state = state.copyWith(songState: SongState.paused);
      } else if (processingState != ProcessingState.completed) {
        state = state.copyWith(songState: SongState.playing);
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.speedStream.listen((double playerSpeedState) {
      if (playerSpeedState == 1.0) {
        state = state.copyWith(speedState: SpeedState.x1);
      } else if (playerSpeedState == 1.5) {
        state = state.copyWith(speedState: SpeedState.x1_5);
      } else if (playerSpeedState == 2) {
        state = state.copyWith(speedState: SpeedState.x2);
      }
    });

    _audioPlayer.positionStream.listen((position) {
      state = state.copyWith(currentPosition: position);
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      state = state.copyWith(bufferedPosition: bufferedPosition);
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      state = state.copyWith(totalDuration: totalDuration ?? Duration.zero);
    });
  }

  void play() {
    final currentlyPlaying = ref.read(currentlyPlayingIdProvider);
    if (currentlyPlaying != urlLink) {
      // Stop currently playing song if any
      if (currentlyPlaying != null) {
        ref.read(playerManagerProvider(currentlyPlaying).notifier).pause();
      }
      // Start playing this song
      _audioPlayer.play();
      // Set currently playing song
      ref.read(currentlyPlayingIdProvider.notifier).state = urlLink;
      // Set current song
      ref.read(currentSongProvider.notifier).state =
          ref.read(cachedSongsProvider.notifier).state?.firstWhere(
                (element) => element.songUrl == urlLink,
              );
    }
  }

  void pause() {
    _audioPlayer.pause();
    // Clear currently playing song
    ref.read(currentlyPlayingIdProvider.notifier).state = null;
  }

  void handlePlayPause() {
    if (state.songState == SongState.paused) {
      play();
    } else if (state.songState == SongState.playing) {
      pause();
    }
  }

  void fastForword() {
    _audioPlayer.seek(_audioPlayer.position + const Duration(seconds: 10));
  }

  void rewind() {
    _audioPlayer.seek(_audioPlayer.position - const Duration(seconds: 10));
  }

  void skipForward() {
    final songs = ref.read(cachedSongsProvider.notifier).state;
    final currentSong = ref.read(currentSongProvider);
    final currentIndex = songs?.indexOf(currentSong!);

    if (currentIndex != null && currentIndex < songs!.length - 1) {
      final nextSong = songs[currentIndex + 1];
      ref.read(playerManagerProvider(nextSong.songUrl ?? '').notifier).play();
    }
  }

  void skipBackward() {
    final songs = ref.read(cachedSongsProvider.notifier).state;
    final currentSong = ref.read(currentSongProvider);
    final currentIndex = songs?.indexOf(currentSong!);

    if (currentIndex != null && currentIndex > 0) {
      final previousSong = songs?[currentIndex - 1];
      ref
          .read(playerManagerProvider(previousSong?.songUrl ?? '').notifier)
          .play();
    }
  }

  void setSpeed(double speed) {
    _audioPlayer.setSpeed(speed);
  }

  void setVolume(double value) {
    _audioPlayer.setVolume(value);
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
