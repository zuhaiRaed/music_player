// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:flutter/material.dart';
// import '/app/screens/elearning/course_content/widgets/lectures/lecture_tabbar/course_note/notes_manager.dart';
// import '../../app/style/common_shapes.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import '/app/style/style.dart';
// import 'audio_manager.dart';

// class MyAudioPlayer extends ConsumerStatefulWidget {
//   final String url;
//   final Function? audioTracker;
//   final int? id;
//   final bool? isFile;
//   final bool? withPosition;

//   const MyAudioPlayer({
//     Key? key,
//     required this.url,
//     this.audioTracker,
//     this.id,
//     this.isFile,
//     this.withPosition,
//   }) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AudioWidgetState();
// }

// class _AudioWidgetState extends ConsumerState<MyAudioPlayer> {
//   late final AudioManager _audioManager;

//   @override
//   void initState() {
//     _audioManager = AudioManager(
//       urlLink: widget.url,
//       videoTracker: widget.audioTracker ?? () {},
//       isFile: widget.isFile ?? false,
//       ref: ref,
//       id: widget.id,
//     );

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _audioManager.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final permission = ref.watch(permissionGoToNoteProvider(widget.id ?? 0));
//     if (widget.withPosition == true && permission == true) {
//       _audioManager.seek(
//         Duration(
//           seconds: ref.watch(goToVideoPositionProvider(widget.id ?? 0)),
//         ),
//       );
//     }
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Style.lines),
//           borderRadius: CommonShapes.containerRadius5,
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//         child: Row(
//           children: [
//             // ======= Play Button ======= //
//             Container(
//               width: 35,
//               height: 35,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Style.primary.withOpacity(0.1),
//               ),
//               child: ValueListenableBuilder<ButtonState>(
//                 valueListenable: _audioManager.buttonNotifier,
//                 builder: (_, value, __) {
//                   getIcon() {
//                     switch (value) {
//                       case ButtonState.loading:
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircularProgressIndicator(
//                             color: Style.primary,
//                             backgroundColor: Colors.transparent,
//                             strokeWidth: 1,
//                           ),
//                         );
//                       case ButtonState.paused:
//                         return Icon(
//                           Icons.play_arrow,
//                           color: Style.primary,
//                         );
//                       case ButtonState.playing:
//                         return Icon(
//                           Icons.pause,
//                           color: Style.primary,
//                         );
//                     }
//                   }

//                   getAction() {
//                     switch (value) {
//                       case ButtonState.loading:
//                         return;
//                       case ButtonState.paused:
//                         return _audioManager.play();
//                       case ButtonState.playing:
//                         return _audioManager.pause();
//                     }
//                   }

//                   return IconButton(
//                     onPressed: () {
//                       getAction();
//                     },
//                     icon: getIcon(),
//                     constraints: const BoxConstraints(),
//                     padding: EdgeInsets.zero,
//                     visualDensity: VisualDensity.compact,
//                   );
//                 },
//               ),
//             ),
//             // ============== Progress Bar ============== //
//             ValueListenableBuilder<ProgressBarState>(
//               valueListenable: _audioManager.progressNotifier,
//               builder: (_, value, __) {
//                 return Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: ProgressBar(
//                       progress: value.current,
//                       buffered: value.buffered,
//                       total: value.total,
//                       progressBarColor: Style.primary,
//                       baseBarColor: Style.primary.withOpacity(0.1),
//                       barHeight: 3,
//                       timeLabelTextStyle: Style.mainFont.bodySmall,
//                       timeLabelType: TimeLabelType.totalTime,
//                       timeLabelLocation: TimeLabelLocation.sides,
//                       thumbGlowRadius: 15,
//                       onSeek: _audioManager.seek,
//                       thumbRadius: 5,
//                     ),
//                   ),
//                 );
//               },
//             ),

//             // ======= Speed Controller ======= //
//             Container(
//               width: 45,
//               height: 30,
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(Radius.circular(50)),
//                 color: Style.primary.withOpacity(0.1),
//               ),
//               child: ValueListenableBuilder<SpeedState>(
//                 valueListenable: _audioManager.speedNotifier,
//                 builder: (_, value, __) {
//                   final style = Style.mainFont.bodySmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Style.primary,
//                   );
//                   getIcon() {
//                     switch (value) {
//                       case SpeedState.x1:
//                         return Text('1.0x', style: style);
//                       case SpeedState.x1_5:
//                         return Text('1.5x', style: style);
//                       case SpeedState.x2:
//                         return Text('2x', style: style);
//                     }
//                   }

//                   return IconButton(
//                     onPressed: () {
//                       switch (value) {
//                         case SpeedState.x1:
//                           return _audioManager.setSpeed(1.5);
//                         case SpeedState.x1_5:
//                           return _audioManager.setSpeed(2);
//                         case SpeedState.x2:
//                           return _audioManager.setSpeed(1.0);
//                       }
//                     },
//                     icon: getIcon(),
//                     constraints: const BoxConstraints(),
//                     padding: EdgeInsets.zero,
//                     visualDensity: VisualDensity.compact,
//                   );
//                 },
//               ),
//             ),
//             // ============== Volumn State ============== //
//             // ValueListenableBuilder<VolumnState>(
//             //   valueListenable: _audioManager.volumNotifier,
//             //   builder: (_, value, __) {
//             //     const color = Style.text;
//             //     switch (value) {
//             //       case VolumnState.off:
//             //         return IconButton(
//             //           icon: Icon(
//             //             Icons.volume_off,
//             //             color: color,
//             //             size: 20 ,
//             //           ),
//             //           onPressed: () => _audioManager.setVolum(0.5),
//             //         );
//             //       case VolumnState.mid:
//             //         return IconButton(
//             //           icon: Icon(
//             //             Icons.volume_down,
//             //             color: color,
//             //             size: 20 ,
//             //           ),
//             //           onPressed: () {
//             //             _audioManager.setVolum(1);
//             //           },
//             //         );
//             //       case VolumnState.max:
//             //         return IconButton(
//             //           icon: Icon(
//             //             Icons.volume_up,
//             //             color: color,
//             //             size: 20 ,
//             //           ),
//             //           onPressed: () {
//             //             _audioManager.setVolum(0);
//             //           },
//             //         );
//             //     }
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
