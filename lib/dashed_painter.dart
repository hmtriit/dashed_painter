library dashed_painter;

import 'dart:ui';

/// {@template dashed_painter}
/// A utility to draw dashed or dotted paths using a `Canvas`.
///
/// Supports both solid dash lines and dot-dash patterns.
/// You can control spacing, dash length, and dot count/width.
///
/// Typical use case is inside `CustomPainter` or custom `Decoration`.
///
/// ```dart
/// final path = Path()..moveTo(0, 0)..lineTo(100, 0);
/// DashedPainter(step: 4, span: 2).paint(canvas, path, paint);
/// ```
/// {@endtemplate}
class DashedPainter {
  /// The length of the solid segment.
  final double step;

  /// The space between dash segments.
  final double span;

  /// Number of small dots after each solid dash.
  final int pointCount;

  /// The length of each dot (if `pointCount > 0`).
  /// If null, defaults to `Paint.strokeWidth`.
  final double? pointWidth;

  /// Creates a new dashed painter with the given dash configuration.
  const DashedPainter({
    this.step = 2.0,
    this.span = 2.0,
    this.pointCount = 0,
    this.pointWidth,
  });

  /// Paints the dashed path to the provided canvas using the given path and paint.
  void paint(Canvas canvas, Path path, Paint paint) {
    final PathMetrics metrics = path.computeMetrics();
    final bool hasDots = pointCount > 0;
    final double dotLength = hasDots ? (pointWidth ?? paint.strokeWidth) : 0.0;
    final double partLength =
        hasDots
            ? step + span * (pointCount + 1) + dotLength * pointCount
            : step + span;

    for (final PathMetric pm in metrics) {
      final double length = pm.length;
      final int fullSegments = length ~/ partLength;

      for (int i = 0; i < fullSegments; i++) {
        final double offset = i * partLength;

        // Solid segment
        final double solidStart = offset;
        final double solidEnd = solidStart + step;
        if (solidEnd <= length) {
          canvas.drawPath(pm.extractPath(solidStart, solidEnd), paint);
        }

        // Dots
        if (hasDots) {
          for (int j = 1; j <= pointCount; j++) {
            final double dotStart = solidEnd + span * j + dotLength * (j - 1);
            final double dotEnd = dotStart + dotLength;
            if (dotEnd <= length) {
              canvas.drawPath(pm.extractPath(dotStart, dotEnd), paint);
            }
          }
        }
      }

      // Draw the remaining tail segment if any
      final double tailStart = fullSegments * partLength;
      if (tailStart < length) {
        canvas.drawPath(pm.extractPath(tailStart, length), paint);
      }
    }
  }
}
