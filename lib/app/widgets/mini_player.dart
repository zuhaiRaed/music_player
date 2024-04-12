import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../controllers/player_manager.dart';
import '../../core/application.dart';
import '../../core/common/load_image.dart';
import '../../core/style/assets.dart';
import '../../core/style/style.dart';
import '../../models/player_state_model.dart';
import '../routes/app_router.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currentSong = ref.watch(currentSongProvider);
    final url = currentSong?.songUrl ?? '';

    return Visibility(
      visible: currentSong != null,
      child: Builder(
        builder: (context) {
          final playerState = ref.watch(playerManagerProvider(url));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                application.appRouter.push(PlayerRoute(song: currentSong!));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 65,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: -4,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: ProgressBar(
                            progress: playerState.currentPosition,
                            buffered: playerState.bufferedPosition,
                            total: playerState.totalDuration,
                            timeLabelLocation: TimeLabelLocation.none,
                            thumbRadius: 0,
                            barHeight: 10,
                            progressBarColor: Style.primary,
                            baseBarColor: Colors.transparent,
                            bufferedBarColor: Colors.transparent,
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
                                    Hero(
                                      tag: currentSong?.songImageUrl ?? '',
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: SizedBox(
                                          height: 42,
                                          width: 42,
                                          child: LoadImage(
                                            imageUrl:
                                                currentSong?.songImageUrl ?? '',
                                            placholder: ImageAssets.logo,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        currentSong?.songName ?? '',
                                        style: Style.secondaryFont.bodyMedium,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        ref
                                            .read(
                                              playerManagerProvider(url)
                                                  .notifier,
                                            )
                                            .handlePlayPause();
                                      },
                                      icon: SvgPicture.asset(
                                        playerState.songState ==
                                                SongState.paused
                                            ? SvgAssets.play
                                            : SvgAssets.pause,
                                        colorFilter: const ColorFilter.mode(
                                          Style.secondary,
                                          BlendMode.srcIn,
                                        ),
                                        height: 22,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        ref
                                            .read(playerManagerProvider(url)
                                                .notifier)
                                            .skipForward();
                                      },
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
            ),
          );
        },
      ),
    );
  }
}
