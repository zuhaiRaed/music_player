class MyPlayerState {
  final SongState songState;
  final SpeedState speedState;
  final Duration currentPosition;
  final Duration bufferedPosition;
  final Duration totalDuration;

  MyPlayerState({
    required this.songState,
    required this.speedState,
    required this.currentPosition,
    required this.bufferedPosition,
    required this.totalDuration,
  });

  factory MyPlayerState.initial() {
    return MyPlayerState(
      songState: SongState.paused,
      speedState: SpeedState.x1,
      currentPosition: Duration.zero,
      bufferedPosition: Duration.zero,
      totalDuration: Duration.zero,
    );
  }

  MyPlayerState copyWith({
    SongState? songState,
    SpeedState? speedState,
    Duration? currentPosition,
    Duration? bufferedPosition,
    Duration? totalDuration,
  }) {
    return MyPlayerState(
      songState: songState ?? this.songState,
      speedState: speedState ?? this.speedState,
      currentPosition: currentPosition ?? this.currentPosition,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

enum SongState { paused, playing, loading }

enum SpeedState { x1, x1_5, x2 }


