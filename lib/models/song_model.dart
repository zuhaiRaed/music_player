import 'dart:convert';
import '../core/utils/generate_id.dart';

class SongModel {
  String id = generateId();
  String? songName;
  String? singerName;
  String? albumName;
  String? songImageUrl;
  String? songUrl;
  int? duration;
  List<int>? waveformData;
  List<SongModel>? queue;

  SongModel({
    this.songName,
    this.singerName,
    this.albumName,
    this.songImageUrl,
    this.songUrl,
    this.duration,
    this.waveformData,
    this.queue,
  });
  factory SongModel.fromJson(String str) => SongModel.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  SongModel.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        songName = json['songName'],
        singerName = json['singerName'],
        albumName = json['albumName'],
        songImageUrl = json['songImageUrl'],
        songUrl = json['songUrl'],
        duration = json['duration'],
        waveformData = json['waveformData'] == null
            ? null
            : List<int>.from(json['waveformData']),
        queue = json['queue'] == null
            ? null
            : List<SongModel>.from(
                json['queue'].map((x) => SongModel.fromMap(x)),
              );

  Map<String, dynamic> toMap() => {
        'id': id.toString(),
        'songName': songName.toString(),
        'singerName': singerName.toString(),
        'albumName': albumName.toString(),
        'songImageUrl': songImageUrl.toString(),
        'songUrl': songUrl.toString(),
        'duration': duration,
        'waveformData': waveformData,
        'queue': queue,
      };

  // copyWith method
  SongModel copyWith({
    String? songName,
    String? singerName,
    String? albumName,
    String? songImageUrl,
    String? songUrl,
    int? duration,
    List<SongModel>? queue,
  }) {
    return SongModel(
      songName: songName ?? this.songName,
      singerName: singerName ?? this.singerName,
      albumName: albumName ?? this.albumName,
      songImageUrl: songImageUrl ?? this.songImageUrl,
      songUrl: songUrl ?? this.songUrl,
      duration: duration ?? this.duration,
      queue: queue ?? this.queue,
    );
  }
}

enum AudioPlayerState { none, stopped, playing, paused }
