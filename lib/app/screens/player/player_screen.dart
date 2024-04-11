import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/common/app_padding.dart';
import '../../../core/common/load_image.dart';
import '../../../core/common/main_button.dart';
import '/core/style/assets.dart';
import '/core/application.dart';
import '/core/style/style.dart';
import 'widgets/waveform_widget.dart';

@RoutePage()
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRect(
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
              child: const LoadImage(
                height: double.infinity,
                width: double.infinity,
                imageUrl: 'https://picsum.photos/200/200',
                placholder: ImageAssets.logo,
                fit: BoxFit.cover,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 100,
                sigmaY: 100,
                tileMode: TileMode.repeated,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Text(application.translate('nowPlaying')),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        SvgAssets.search,
                        colorFilter: const ColorFilter.mode(
                          Style.secondary,
                          BlendMode.srcATop,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    const Spacer(),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const AudioWaveform(
                          url:
                              'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                        ),
                        const ClipOval(
                          child: LoadImage(
                            height: 249,
                            width: 249,
                            imageUrl: 'https://picsum.photos/200/100',
                            placholder: ImageAssets.logo,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 229,
                          width: 229,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Style.secondary.withOpacity(0.55),
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 46),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainButton(
                            text: application.translate('follow'),
                            onPressed: () {},
                            isBordered: true,
                            icon: SvgPicture.asset(
                              SvgAssets.favorite,
                            ),
                            color: Style.secondary,
                          ),
                          MainButton(
                            text: application.translate('shufflePlay'),
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              SvgAssets.shuffle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Text(
                      'Finally Found You',
                      style: Style.mainFont.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'enrique iglesias',
                      style: Style.mainFont.bodyMedium,
                    ),
                    const Spacer(flex: 2),
                    AppPadding(
                      child: ProgressBar(
                        progress: const Duration(
                          minutes: 1,
                          seconds: 28,
                        ),
                        total: const Duration(
                          minutes: 3,
                          seconds: 40,
                        ),
                        baseBarColor: Style.secondary.withOpacity(0.49),
                        thumbColor: Style.secondary,
                        thumbRadius: 6,
                        thumbGlowRadius: 12,
                        barHeight: 3,
                        timeLabelLocation: TimeLabelLocation.sides,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            SvgAssets.skipBackward,
                            colorFilter: const ColorFilter.mode(
                              Style.secondary,
                              BlendMode.srcIn,
                            ),
                            height: 14,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            SvgAssets.rewind,
                            colorFilter: const ColorFilter.mode(
                              Style.secondary,
                              BlendMode.srcIn,
                            ),
                            height: 14,
                          ),
                        ),
                        Container(
                          height: 72,
                          width: 72,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Style.secondary,
                          ),
                          child: IconButton(
                            alignment: Alignment.center,
                            // visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              print('asd');
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Style.surface,
                              size: 50,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            SvgAssets.fastForward,
                            colorFilter: const ColorFilter.mode(
                              Style.secondary,
                              BlendMode.srcIn,
                            ),
                            height: 14,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            SvgAssets.skipForward,
                            colorFilter: const ColorFilter.mode(
                              Style.secondary,
                              BlendMode.srcIn,
                            ),
                            height: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg


