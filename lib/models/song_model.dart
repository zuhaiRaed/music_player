import 'dart:convert';
import 'dart:typed_data';

import '../core/utils/generate_id.dart';

class SongModel {
  String songId = generateId();
  String? songName;
  String? singerName;
  String? albumName;
  String? songImageUrl;
  int? duration;
  String? status;
  Uint8List? waveformData;

  SongModel({
    this.songName,
    this.singerName,
    this.albumName,
    this.songImageUrl,
    this.duration,
    this.status,
    this.waveformData,
  });
  factory SongModel.fromJson(String str) => SongModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  SongModel.fromMap(Map<String, dynamic> json)
      : songId = json['songId'],
        songName = json['songName'],
        singerName = json['singerName'],
        albumName = json['albumName'],
        songImageUrl = json['songImageUrl'],
        duration = json['duration'],
        status = json['status'],
        waveformData = json['waveformData'] != null
            ? Uint8List.fromList(json['waveformData'].cast<int>())
            : null;

  Map<String, dynamic> toMap() => {
        'songId': songId.toString(),
        'songName': songName.toString(),
        'singerName': singerName.toString(),
        'albumName': albumName.toString(),
        'songImageUrl': songImageUrl.toString(),
        'duration': duration,
        'status': status.toString(),
        'waveformData': waveformData?.toList(),
      };
}
