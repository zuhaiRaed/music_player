import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/style/style.dart';

class AudioService {
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
}

class WaveformPainter extends CustomPainter {
  final Uint8List waveform;
  WaveformPainter(this.waveform);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Style.secondary.withOpacity(0.8)
      ..strokeWidth = 0.5 // Adjust the stroke width to reduce the 'density'
      ..style = PaintingStyle.stroke; // Use stroke to draw lines

    // Center line of the waveform
    double centerY = size.height / 2;
    // How many pixels each waveform line will take up on the canvas
    double pixelsPerWaveLine = 1; // Adjust this to 'zoom in' on the waveform

    // Process every pair of bytes
    for (int i = 0; i < waveform.length - 1; i += 2) {
      int sample = (waveform[i + 1] << 8) | waveform[i];
      // Convert to signed 16-bit value
      sample = sample & 0x8000 != 0 ? sample - 0xFFFF - 1 : sample;
      // Normalize to the range of the canvas
      double y = (sample / 32768.0) * centerY;

      // Determine the X position of the waveform line
      double x = (i / 2) * pixelsPerWaveLine;
      if (x < size.width) {
        // Draw the line for this sample
        canvas.drawLine(
          Offset(x, centerY - y), // Start at the max amplitude of this sample
          Offset(x, centerY + y), // Draw to the min amplitude of this sample
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AudioWaveform extends StatefulWidget {
  final String url;
  const AudioWaveform({super.key, required this.url});

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform> {
  Uint8List? _waveform;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    final filePath = await AudioService.fetchAudio(widget.url);
    if (filePath != null) {
      final waveform = await AudioService.decodeAudio(filePath);
      if (waveform != null) {
        setState(() => _waveform = waveform);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_waveform);
    return _waveform != null
        ? CustomPaint(
            painter: WaveformPainter(_waveform!),
            size: const Size(double.infinity, 60), // Set your desired height
          )
        : LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Style.secondary.withOpacity(0.4)),
            backgroundColor: Style.secondary.withOpacity(0.1),
          );
  }
}
