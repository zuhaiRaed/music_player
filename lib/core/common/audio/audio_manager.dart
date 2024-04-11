// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '/app/screens/elearning/course_content/widgets/lectures/lecture_tabbar/course_note/notes_manager.dart';
// import '../videos/video_manager.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioManager {
//   final String urlLink;
//   final Function videoTracker;
//   final bool isFile;
//   final WidgetRef? ref;
//   final int? id;

//   final progressNotifier = ValueNotifier<ProgressBarState>(
//     ProgressBarState(
//       current: Duration.zero,
//       buffered: Duration.zero,
//       total: Duration.zero,
//     ),
//   );
//   final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
//   final speedNotifier = ValueNotifier<SpeedState>(SpeedState.x1);
//   final volumNotifier = ValueNotifier<VolumnState>(VolumnState.mid);

//   late AudioPlayer _audioPlayer;
//   AudioManager({
//     required this.urlLink,
//     required this.videoTracker,
//     required this.isFile,
//     this.ref,
//     required this.id,
//   }) {
//     _init();
//   }

//   void _init() async {
//     _audioPlayer = AudioPlayer();
//     isFile == true
//         ? await _audioPlayer.setFilePath(urlLink)
//         : await _audioPlayer.setUrl(urlLink);

//     _audioPlayer.playerStateStream.listen((playerState) {
//       final isPlaying = playerState.playing;
//       final processingState = playerState.processingState;

//       if (processingState == ProcessingState.loading ||
//           processingState == ProcessingState.buffering) {
//         buttonNotifier.value = ButtonState.loading;
//       } else if (!isPlaying) {
//         buttonNotifier.value = ButtonState.paused;
//       } else if (processingState != ProcessingState.completed) {
//         buttonNotifier.value = ButtonState.playing;
//       } else {
//         _audioPlayer.seek(Duration.zero);
//         _audioPlayer.pause();
//       }
//     });

//     _audioPlayer.speedStream.listen((double playerSpeedState) {
//       if (playerSpeedState == 1.0) {
//         speedNotifier.value = SpeedState.x1;
//       } else if (playerSpeedState == 1.5) {
//         speedNotifier.value = SpeedState.x1_5;
//       } else if (playerSpeedState == 2) {
//         speedNotifier.value = SpeedState.x2;
//       }
//     });

//     _audioPlayer.volumeStream.listen((volumn) {
//       if (volumn == 0.0) {
//         volumNotifier.value = VolumnState.off;
//       } else if (volumn == 0.5) {
//         volumNotifier.value = VolumnState.mid;
//       } else if (volumn == 1.0) {
//         volumNotifier.value = VolumnState.max;
//       }
//     });
//     _audioPlayer.positionStream.listen((position) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: position,
//         buffered: oldState.buffered,
//         total: oldState.total,
//       );

//       WidgetsBinding.instance.addPostFrameCallback((timestamp) {
//         if (ref?.context.mounted == true) {
//           ref?.read(mediaPositionProvider(id ?? 0).notifier).state =
//               _audioPlayer.position.inSeconds;
//           final permission = ref?.watch(permissionGoToNoteProvider(id ?? 0));
//           final position2 = ref?.watch(goToVideoPositionProvider(id ?? 0)) ?? 0;

//           if (permission == true) {
//             _audioPlayer.seek(Duration(seconds: position2)).then((value) {
//               ref?.read(permissionGoToNoteProvider(id ?? 0).notifier).state =
//                   false;
//               ref?.read(goToVideoPositionProvider(id ?? 0).notifier).state =
//                   position2 + 1;
//             });
//           }
//         }
//       });
//     });

//     _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: oldState.current,
//         buffered: bufferedPosition,
//         total: oldState.total,
//       );
//     });

//     _audioPlayer.durationStream.listen((totalDuration) {
//       final oldState = progressNotifier.value;
//       progressNotifier.value = ProgressBarState(
//         current: oldState.current,
//         buffered: oldState.buffered,
//         total: totalDuration ?? Duration.zero,
//       );
//     });

//     _audioPlayer.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed) {
//         videoTracker();
//       }
//     });
//   }

//   void play() {
//     _audioPlayer.play();
//   }

//   void pause() {
//     _audioPlayer.pause();
//   }

//   void setSpeed(double speed) {
//     _audioPlayer.setSpeed(speed);
//   }

//   void setVolum(double value) {
//     _audioPlayer.setVolume(value);
//   }

//   void seek(Duration position) {
//     _audioPlayer.seek(position);
//   }

//   void dispose() {
//     _audioPlayer.dispose();
//   }
// }

// class ProgressBarState {
//   ProgressBarState({
//     required this.current,
//     required this.buffered,
//     required this.total,
//   });
//   final Duration current;
//   final Duration buffered;
//   final Duration total;
// }

// enum ButtonState { paused, playing, loading }

// enum SpeedState { x1, x1_5, x2 }

// enum VolumnState { off, mid, max }
