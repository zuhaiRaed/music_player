import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/style/style.dart';
import '../../../models/song_model.dart';

@RoutePage()
class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final demoSongs = [
      SongModel(
        songName: 'Shape of You',
        singerName: 'Ed Sheeran',
        albumName: 'Divide',
        songImageUrl: 'https://i.scdn.co/image/ab67616d0000b273',
        duration: 234,
        status: 'play',
        waveformData: Uint8List.fromList([
          10,
          20,
          30,
          40,
          50,
          60,
          70,
          80,
          90,
          100,
          110,
          120,
          130,
          140,
          150,
          160,
          170,
          180,
          190,
          200,
        ]),
      ),
      SongModel(
        songName: 'Blinding Lights',
        singerName: 'The Weeknd',
        albumName: 'After Hours',
        songImageUrl: 'https://i.scdn.co/image/ab67616d0000b273',
        duration: 234,
        status: 'play',
        waveformData: Uint8List.fromList([
          10,
          20,
          30,
          40,
          50,
          60,
          70,
          80,
          90,
          100,
          110,
          120,
          130,
          140,
          150,
          160,
          170,
          180,
          190,
          200,
        ]),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Add the songListIwantToAddToFirebase to Firebase
            ElevatedButton(
              onPressed: () async {
                FirebaseFirestore firestore = FirebaseFirestore.instance;

                for (var song in demoSongs) {
                  await firestore.collection('songs').add({
                    'songName': song.songName,
                    'singerName': song.singerName,
                    'albumName': song.albumName,
                    'songImageUrl': song.songImageUrl,
                    'duration': song.duration,
                    'status': song.status,
                    'waveformData': song.waveformData,
                  });
                }
              },
              child: const Text('Add Songs to Firestore'),
            ),

            Center(
              child: Text(
                'Podcast',
                style: Style.mainFont.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
