import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../controllers/player_controller.dart';
import '../../../models/player_state_model.dart';
import '/controllers/firebase_controller.dart';
import '/core/application.dart';
import '/core/common/error_widget.dart';
import '/core/style/assets.dart';
import '/core/style/style.dart';
import '/core/utils/utils.dart';
import '../../routes/app_router.dart';
import '../../widgets/shimmer/songs_list_shimmer.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final getSongs = ref.watch(getSongsProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(application.translate('allSongs').toUpperCase()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              SvgAssets.search,
              colorFilter:
                  const ColorFilter.mode(Style.secondary, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: getSongs.when(
        data: (songData) {
          return songData.isEmpty
              ? const Center(child: Text('No songs found'))
              : ListView.builder(
                  itemCount: songData.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final song = songData[index];
                    final playerState =
                        ref.watch(playerManagerProvider(song.songUrl ?? ''));

                    final isPlayed = playerState.songState == SongState.playing;
                    final isSelected = ref.watch(currentSongProvider) == song;

                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          song.songName ?? '',
                          style: Style.mainFont.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        song.albumName ?? '',
                        style: Style.mainFont.bodySmall,
                      ),
                      trailing: Text(
                        Utils.timerFormat(song.duration ?? 0),
                        style: Style.mainFont.bodySmall,
                      ),
                      leading: GestureDetector(
                        onTap: () {
                          ref
                              .read(
                                playerManagerProvider(song.songUrl ?? '')
                                    .notifier,
                              )
                              .handlePlayPause();
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              isPlayed ? Style.primary : Style.secondary,
                          radius: 17,
                          child: SvgPicture.asset(
                            isPlayed ? SvgAssets.pause : SvgAssets.play,
                            colorFilter: ColorFilter.mode(
                              isPlayed ? Style.secondary : Style.primary,
                              BlendMode.srcIn,
                            ),
                            height: 12,
                          ),
                        ),
                      ),
                      selectedTileColor: Style.secondary.withOpacity(0.1),
                      selected: isSelected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      onTap: () {
                        application.appRouter.push(PlayerRoute(song: song));
                      },
                    );
                  },
                );
        },
        error: (e, er) => MyErrorWidget(
          onPressed: () {
            ref.invalidate(getSongsProvider);
          },
        ),
        loading: () => const SongsListShimmer(),
      ),
    );
  }
}
