import 'package:dashed_painter/dashed_painter.dart';
import 'package:flutter/material.dart';

class BenchmarkPainter extends CustomPainter {
  final int lineCount;
  final double spacing;
  final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.left,
  );

  BenchmarkPainter({required this.lineCount, this.spacing = 10.0});

  late final DashedPainter dashedPainter = DashedPainter(step: 4, span: 4);

  @override
  void paint(Canvas canvas, Size size) {
    final Stopwatch stopwatch = Stopwatch()..start();

    final paint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    for (int i = 0; i < lineCount; i++) {
      final double y = i * spacing + 10;
      final path =
          Path()
            ..moveTo(0, y)
            ..lineTo(size.width, y);
      dashedPainter.paint(canvas, path, paint);
    }

    stopwatch.stop();

    // Hiển thị thời gian vẽ (ms)
    final textSpan = TextSpan(
      text:
          'Lines: $lineCount\nPaint time: ${stopwatch.elapsedMilliseconds} ms',
      style: TextStyle(color: Colors.red, fontSize: 14),
    );

    _textPainter.text = textSpan;
    _textPainter.layout(maxWidth: size.width);
    _textPainter.paint(canvas, const Offset(10, 10));
  }

  @override
  bool shouldRepaint(covariant BenchmarkPainter oldDelegate) {
    return oldDelegate.lineCount != lineCount;
  }
}
