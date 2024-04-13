import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/core/common/error_widget.dart';
import '/controllers/firebase_controller.dart';
import '/core/common/common_ui.dart';
import '/core/common/main_button.dart';
import '/models/song_model.dart';

@RoutePage()
class FirebaseManageScreen extends HookConsumerWidget {
  const FirebaseManageScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isLoading = useState(false);

    final demoSongs = [
      SongModel(
        songName: 'Shape of You',
        singerName: 'Ed Sheeran',
        albumName: 'Divide',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2FshapeOfYou.jpeg?alt=media&token=90767a28-1a4d-4b01-927c-04130b890664',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Ed%20Sheeran%20-%20Shape%20of%20You%20(Official%20Music%20Video).mp3?alt=media&token=a3fe6477-ed46-4928-8002-a34e4625f7cd',
      ),
      SongModel(
        songName: 'Someone Like You',
        singerName: 'Adele',
        albumName: '21',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2Fsomeone%20like%20you.jpeg?alt=media&token=cded4b49-449b-4b6d-a931-eddc4a0e1608',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Adele%20-%20Someone%20Like%20You%20(Official%20Music%20Video).mp3?alt=media&token=c8ee0c01-a23d-42f7-a4c0-fbf15dda0708',
      ),
      SongModel(
        songName: 'Stairway to Heaven',
        singerName: 'Led Zeppelin',
        albumName: 'Led Zeppelin IV',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2F9.27.21_Masterpiece-1024x683-1.jpg?alt=media&token=02a220d8-7d0c-43d1-91d7-9826bd220921',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Led%20Zeppelin%20-%20Stairway%20To%20Heaven%20(Official%20Audio).mp3?alt=media&token=be595834-d43f-40c2-b947-bf5da81c5c2f',
      ),
      SongModel(
        songName: 'Bohemian Rhapsody',
        singerName: 'Queen',
        albumName: 'A Night at the Opera',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2Fab67616d0000b27328581cfe196c266c132a9d62.jpeg?alt=media&token=fccf33f0-b67e-45c6-b248-07a40cfb4bc2',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Queen%20%20Bohemian%20Rhapsody%20(Official%20Video%20Remastered).mp3?alt=media&token=57de7ab3-3c2d-4bb4-9a34-b3e2547c61d9',
      ),
      SongModel(
        songName: 'Hotel California',
        singerName: 'Eagles',
        albumName: 'Hotel California',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2Feagles2.png?alt=media&token=f30d6368-0f65-4928-9cdb-ac06af6e4a8a',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Hotel%20California%20(2013%20Remaster).mp3?alt=media&token=ddfcac65-0076-47c9-ad96-4117a1ec7964',
      ),
      SongModel(
        songName: 'Imagine',
        singerName: 'John Lennon',
        albumName: 'Imagine',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2Fartworks-000081989828-qzlmpu-t500x500.jpg?alt=media&token=236975c8-cbc7-4f4b-aa7c-b6c8888c2f3c',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/John%20Lennon%20Imagine%20Official%20video%20(HD).mp3?alt=media&token=e2910b2e-888c-4ce4-9641-123e684dfe63',
      ),
      SongModel(
        songName: 'Billie Jean',
        singerName: 'Michael Jackson',
        albumName: 'Thriller',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2Fbillie-jean-2010-this-is-it-tour-v0-n1m0yqxliosb1.webp?alt=media&token=90711922-7d8f-4fe0-8157-b6f90df23cca',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Michael%20Jackson%20-%20Billie%20Jean%20(Official%20Video).mp3?alt=media&token=2db19fa1-35c6-45a6-9c23-dddd8443388d',
      ),
      SongModel(
        songName: 'Finally Found You',
        singerName: 'Enrique Iglesias',
        albumName: ' Sex and Love',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2F960x0.webp?alt=media&token=07449d5f-0f46-4fa1-adaa-30dd87faac81',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Enrique%20Iglesias%20-%20Finally%20Found%20You%20ft.%20Sammy%20Adams.mp3?alt=media&token=4df472da-4204-4178-8d27-09706e681afe',
      ),
      SongModel(
        songName: 'Smells Like Teen Spirit',
        singerName: 'Nirvana',
        albumName: 'Nevermind',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2Fmaxresdefault.jpg?alt=media&token=9975bb93-7b95-4de8-a856-29aaabbee180',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Nirvana%20-%20Smells%20Like%20Teen%20Spirit%20(Official%20Music%20Video).mp3?alt=media&token=32d414ed-e12e-4a50-a2c8-c9c36e7c73a2',
      ),
      SongModel(
        songName: 'Until I Found You',
        singerName: 'stephen sanchez',
        albumName: 'Angel Face',
        songImageUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/images%2Fmaxresdefault%20(1).jpg?alt=media&token=1557e3d2-09f5-45ba-aedb-22c8f4743dd8',
        songUrl:
            'https://firebasestorage.googleapis.com/v0/b/musicplayer-9ab88.appspot.com/o/Stephen%20Sanchez%20-%20Until%20I%20Found%20You%20(Lyrics).mp3?alt=media&token=686ddc17-e77d-43f8-9103-4f6c2286f1bf',
      ),
    ];

    final firebaseController = ref.watch(firebaseControllerProvider);
    final getSongs = ref.watch(getSongsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Manager Screen'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: getSongs.when(
                data: (song) => ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(song[index].songName ?? ''),
                      subtitle: Text(song[index].albumName ?? ''),
                      trailing: IconButton(
                        onPressed: () {
                          CommonUi.messageDialog(
                            context,
                            title: 'Delete Song',
                            message:
                                'Are you sure you want to delete this song?',
                            onConfirm: () {
                              firebaseController.deleteSong(song[index].id);
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  },
                  itemCount: song.length,
                ),
                error: (e, er) {
                  return MyErrorWidget(
                    onPressed: () {
                      firebaseController.getSongs();
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            MainButton(
              isLoading: isLoading.value,
              onPressed: () async {
                isLoading.value = true;

                // first check if the song is already added to Firestore or not
                // if not then add the song to Firestore
                final songsInFirebase = ref.watch(cachedSongsProvider);
                for (var song in demoSongs) {
                  (songsInFirebase ?? [])
                          .where((element) => element.songName == song.songName)
                          .toList()
                          .isEmpty
                      ? await firebaseController.addSong(song).then((value) {
                          isLoading.value = false;
                          if (value) {
                            CommonUi.snackBar(
                              context,
                              '${song.songName} added to Firestore',
                              backgroundColor: Colors.green,
                            );
                          } else {
                            CommonUi.snackBar(
                              context,
                              'Failed to add ${song.songName} to Firestore',
                              backgroundColor: Colors.red,
                            );
                          }
                        })
                      : {
                          isLoading.value = false,
                          CommonUi.snackBar(
                            context,
                            '${song.songName} already added to Firestore',
                            backgroundColor: Colors.orange,
                          ),
                        };
                }
              },
              text: ('Add Songs From List to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
