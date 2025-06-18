library dash_painter;

import 'dart:ui';

// [step] the length of solid line
// [span] the space of each solid line
// [pointCount] the point count of dash line
// [pointWidth] the point width of dash line

class DashPainter {
  const DashPainter({
    this.step = 2,
    this.span = 2,
    this.pointCount = 0,
    this.pointWidth,
  });

  final double step;
  final double span;
  final int pointCount;
  final double? pointWidth;

  void paint(Canvas canvas, Path path, Paint paint) {
    final PathMetrics pathMetrics = path.computeMetrics();
    final double pointLineLength = pointWidth ?? paint.strokeWidth;
    final double partLength =
        step + span * (pointCount + 1) + pointCount * pointLineLength;

    for (var pm in pathMetrics) {
      final int count = pm.length ~/ partLength;

      // Pre-calculate paint operations for better performance
      for (int i = 0; i < count; i++) {
        // Draw the solid line segment
        final double solidStart = partLength * i;
        canvas.drawPath(pm.extractPath(solidStart, solidStart + step), paint);

        // Draw the point segments if needed
        if (pointCount > 0) {
          for (int j = 1; j <= pointCount; j++) {
            final double start =
                solidStart + step + span * j + pointLineLength * (j - 1);
            canvas.drawPath(
              pm.extractPath(start, start + pointLineLength),
              paint,
            );
          }
        }
      }

      // Handle the remaining path segment
      final double tail = pm.length % partLength;
      if (tail > 0) {
        canvas.drawPath(pm.extractPath(pm.length - tail, pm.length), paint);
      }
    }
  }
}
