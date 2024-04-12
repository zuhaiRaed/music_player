import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/core/common/load_image.dart';
import '/core/common/main_button.dart';
import '/models/song_model.dart';
import '/core/style/assets.dart';
import '/core/application.dart';
import '/core/style/style.dart';
import 'widgets/my_audio_player.dart';
import 'widgets/waveform_widget.dart';

@RoutePage()
class PlayerScreen extends ConsumerWidget {
  final SongModel song;
  const PlayerScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      body: ClipRect(
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
              child: LoadImage(
                height: double.infinity,
                width: double.infinity,
                imageUrl: song.songImageUrl ?? '',
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
                        AudioWaveform(waveform: song.waveformData),
                        Hero(
                          tag: song.songImageUrl ?? '',
                          child: ClipOval(
                            child: LoadImage(
                              height: 249,
                              width: 249,
                              imageUrl: song.songImageUrl ?? '',
                              placholder: ImageAssets.logo,
                              fit: BoxFit.cover,
                            ),
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
                      song.songName ?? '',
                      style: Style.mainFont.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      song.singerName ?? '',
                      style: Style.mainFont.bodyMedium,
                    ),
                    const Spacer(flex: 2),
                    MyAudioPlayer(url: song.songUrl ?? ''),
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
