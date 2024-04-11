import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/common/load_image.dart';
import '../../core/style/assets.dart';
import '../../core/style/style.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 65,
          child: Stack(
            children: [
              const Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: ProgressBar(
                    timeLabelLocation: TimeLabelLocation.none,
                    thumbRadius: 0,
                    barHeight: 10,
                    progressBarColor: Style.primary,
                    baseBarColor: Colors.transparent,
                    bufferedBarColor: Colors.transparent,
                    progress: Duration(seconds: 10),
                    total: Duration(seconds: 30),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 60,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 28,
                        sigmaY: 28,
                        tileMode: TileMode.clamp,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const SizedBox(
                                height: 42,
                                width: 42,
                                child: LoadImage(
                                  imageUrl: 'https://picsum.photos/200/300',
                                  placholder: ImageAssets.logo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Song Name',
                                style: Style.secondaryFont.bodyMedium,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                SvgAssets.pause,
                                colorFilter: const ColorFilter.mode(
                                  Style.secondary,
                                  BlendMode.srcIn,
                                ),
                                height: 22,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                SvgAssets.next,
                                colorFilter: const ColorFilter.mode(
                                  Style.secondary,
                                  BlendMode.srcIn,
                                ),
                                height: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
