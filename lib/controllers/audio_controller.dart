import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioController {
  static final FlutterSoundHelper _soundHelper = FlutterSoundHelper();

  static Future<String?> fetchAudio(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/temp.wav';
      final file = File(filePath);
      await file.writeAsBytes(response.data);
      return filePath;
    } catch (e) {
      debugPrint('Error fetching audio: $e');
      return null;
    }
  }

  static Future<Uint8List?> decodeAudio(String filePath) async {
    try {
      // Load the audio file into memory
      final File file = File(filePath);
      final Uint8List inputBuffer = await file.readAsBytes();

      // Decode the audio file from the buffer
      final decodedData =
          _soundHelper.waveToPCMBuffer(inputBuffer: inputBuffer);

      return decodedData;
    } catch (e) {
      debugPrint('Error decoding audio: $e');
      return null;
    }
  }

  static Future<int?> getAudioDuration(String audioUrl) async {
    final AudioPlayer audioPlayer = AudioPlayer();

    try {
      // Fetch the audio duration from the network
      await audioPlayer.setUrl(audioUrl);
      final duration = audioPlayer.duration;
      // Convert duration to seconds
      return duration?.inSeconds;
    } catch (e) {
      debugPrint('Error getting audio duration: $e');
      return null;
    } finally {
      audioPlayer.dispose();
    }
  }
}
