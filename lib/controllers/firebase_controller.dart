import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/song_model.dart';
import 'audio_controller.dart';

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// final getSongsProvider = FutureProvider<List<SongModel>>((ref) {
//   final firebaseController = ref.watch(firebaseControllerProvider);
//   return firebaseController.getSongs();
// });

final getSongsProvider = StreamProvider.autoDispose<List<SongModel>>((ref) {
  final controller = StreamController<List<SongModel>>();
  FirebaseFirestore.instance
      .collection(ref.watch(firebaseControllerProvider).songsCollection)
      .snapshots()
      .listen((event) {
    final listOfSongs = event.docs.map<SongModel>((doc) {
      return SongModel.fromMap(doc.data());
    }).toList();
    controller.add(listOfSongs);
    ref.read(cachedSongsProvider.notifier).state = listOfSongs;
  });

  ref.onDispose(() {
    controller.close();
  });
  return controller.stream;
});

final cachedSongsProvider = StateProvider<List<SongModel>?>((ref) {
  return [];
});

final firebaseControllerProvider =
    Provider<FirebaseController>((ref) => FirebaseController(ref));

class FirebaseController {
  final Ref ref;

  FirebaseController(this.ref);

  FirebaseFirestore get firestore => ref.read(firebaseFirestoreProvider);
  String get songsCollection => 'tracks';
  Future<List<SongModel>> getSongs() async {
    final songsSnapshot = await firestore.collection(songsCollection).get();
    final listOfSongs =
        songsSnapshot.docs.map((doc) => SongModel.fromMap(doc.data())).toList();
    ref.read(cachedSongsProvider.notifier).state = listOfSongs;
    return listOfSongs;
  }

  Future<List<int>?> generateWaveform(String songUrl) async {
    final filePath = await AudioController.fetchAudio(songUrl);
    if (filePath != null) {
      final waveform = await AudioController.decodeAudio(filePath);
      if (waveform != null) {
        return waveform;
      }
    }
    return [];
  }

  Future<int?> getDuration(String songUrl) async {
    final duration = await AudioController.getAudioDuration(songUrl);

    return duration;
  }

  Future<bool> addSong(SongModel song) async {
    try {
      await generateWaveform(song.songUrl ?? '').then((value) {
        int sequentialZerosCount = 0;
        final random = Random();

        // I made this loop to generate random values for the waveform data if there are sequential zeros, because the waveform data is too large and it's not good to upload it to Firestore as it is.(For Design purposes only)
        for (int i = 0; i < value!.length; i++) {
          if (value[i] == 0) {
            sequentialZerosCount++;
            if (sequentialZerosCount > 10) {
              // Generate a random value between 1 and 100 (inclusive)
              value[i] = random.nextInt(100) + 1;
            }
          } else {
            sequentialZerosCount = 0;
          }
        }

        final List<int> waveformList = value.map((e) => e.toInt()).toList();

        final List<int> firstHalf = waveformList.sublist(0, 51027);
        song.waveformData = firstHalf;
      });

      await getDuration(song.songUrl ?? '').then((value) {
        song.duration = value;
      });

      await firestore.collection(songsCollection).doc(song.id).set({
        'id': song.id,
        'songName': song.songName,
        'singerName': song.singerName,
        'albumName': song.albumName,
        'songImageUrl': song.songImageUrl,
        'songUrl': song.songUrl,
        'duration': song.duration,
        'waveformData': song.waveformData,
      });
      debugPrint('Song added to Firestore');
      return true;
    } catch (e) {
      debugPrint('Song Failed  ');

      return false;
    }
  }

  deleteSong(String songId) async {
    try {
      await firestore.collection(songsCollection).doc(songId).delete();
      debugPrint('Song deleted from Firestore');
    } catch (e) {
      debugPrint('Failed to delete song from Firestore');
    }
  }
}
