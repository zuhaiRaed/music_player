import 'package:flutter/material.dart';
import '/core/style/style.dart';

class WaveformPainter extends CustomPainter {
  final List<int> waveform;
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
    double pixelsPerWaveLine = 2; // Adjust this to 'zoom in' on the waveform

    // Process every pair of bytes
    for (int i = 0; i < waveform.length - 1; i += 2) {
      int sample = (waveform[i + 1] << 8) | waveform[i];
      // Convert to signed 16-bit value
      sample = sample & 0x8000 != 0 ? sample - 0xFFFF - 1 : sample;
      // Normalize to the range of the canvas
      double y = (sample / 22768.0) * centerY;

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

class AudioWaveform extends StatelessWidget {
  final List<int>? waveform;
  const AudioWaveform({super.key, required this.waveform});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveformPainter(waveform ?? []),
      size: const Size(double.infinity, 60), // Set your desired height
    );
  }
}
