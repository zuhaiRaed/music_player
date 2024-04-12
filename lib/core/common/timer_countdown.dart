// import 'package:flutter/material.dart';

// import '../style/style.dart';

// class Countdown extends StatefulWidget {
//   final int minutes;
//   final String startTime;
//   final Function onFinishTimer;
//   final Color? color;
//   final bool? withProgress;
//   final TextStyle? textStyle;
//   const Countdown({
//     super.key,
//     required this.minutes,
//     required this.onFinishTimer,
//     required this.startTime,
//     this.color,
//     this.withProgress = false,
//     this.textStyle,
//   });

//   @override
//   State<Countdown> createState() => _CountdownState();
// }

// class _CountdownState extends State<Countdown> with TickerProviderStateMixin {
//   late AnimationController timeController;

//   String get countText {
//     Duration count = timeController.duration! * timeController.value;
//     return '${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
//   }

//   double progress = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     var duration = DateTime.parse(widget.startTime)
//         .add(Duration(seconds: (widget.minutes) * 60))
//         .difference(DateTime.now())
//         .inSeconds;
//     timeController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: duration.isNegative ? 0 : duration),
//     );
//     timeController.reverse(
//       from: timeController.value == 0 ? 1.0 : timeController.value,
//     );
//     timeController.addListener(() {
//       if (timeController.isAnimating) {
//         setState(() {
//           progress = timeController.value;
//         });
//       }
//       if (timeController.value == 0) {
//         widget.onFinishTimer();
//       }

//       if (duration.isNegative) {
//         widget.onFinishTimer();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         if (widget.withProgress == true)
//           SizedBox(
//             width: 20,
//             height: 20,
//             child: CircularProgressIndicator(
//               value: progress,
//               strokeWidth: 2,
//               backgroundColor: Style.primary.withOpacity(0.1),
//               color: widget.color ?? Style.primary,
//             ),
//           ),
//         if (widget.withProgress == true) const SizedBox(width: 8),
//         AnimatedBuilder(
//           animation: timeController,
//           builder: (context, child) => Text(
//             countText,
//             style: widget.textStyle ??
//                 Style.mainFont.bodyLarge?.copyWith(
//                   color: widget.color ?? Style.secondary,
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     timeController.dispose();
//     super.dispose();
//   }
// }
