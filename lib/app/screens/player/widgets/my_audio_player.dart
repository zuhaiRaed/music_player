import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../models/player_state_model.dart';
import '/core/common/app_padding.dart';
import '/core/style/assets.dart';
import '/core/style/style.dart';
import '../../../../controllers/player_manager.dart';

class MyAudioPlayer extends HookConsumerWidget {
  final String url;
  const MyAudioPlayer({super.key, required this.url});
  @override
  Widget build(BuildContext context, ref) {
    final playerState = ref.watch(playerManagerProvider(url));

    getIcon() {
      switch (playerState.songState) {
        case SongState.paused:
          return const Icon(
            Icons.play_arrow,
            color: Style.surface,
            size: 50,
          );
        case SongState.playing:
          return const Icon(
            Icons.pause,
            color: Style.surface,
            size: 50,
          );

        case SongState.loading:
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Style.secondary),
          );
      }
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          AppPadding(
            child: ProgressBar(
              progress: playerState.currentPosition,
              buffered: playerState.bufferedPosition,
              total: playerState.totalDuration,
              baseBarColor: Style.secondary.withOpacity(0.49),
              thumbColor: Style.secondary,
              thumbRadius: 6,
              thumbGlowRadius: 12,
              barHeight: 3,
              timeLabelLocation: TimeLabelLocation.sides,
              onSeek: (duration) {
                ref.read(playerManagerProvider(url).notifier).seek(duration);
              },
            ),
          ),
          const SizedBox(height: 32),
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
                onPressed: () {
                  ref.read(playerManagerProvider(url).notifier).rewind();
                },
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
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    ref
                        .read(playerManagerProvider(url).notifier)
                        .handlePlayPause();
                  },
                  icon: getIcon(),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(playerManagerProvider(url).notifier).fastForword();
                },
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
        ],
      ),
    );
  }
}
