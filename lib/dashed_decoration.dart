import 'package:flutter/material.dart';
import 'dashed_painter.dart';

/// {@template dashed_decoration}
/// A custom `Decoration` that draws a dashed (or dotted) border
/// around a widget such as a `Container`, `Card`, or any `Box` widget.
///
/// Supports:
/// - Solid dashes and dot-dash patterns
/// - Configurable spacing, thickness, corner radius
/// - Optional gradient or solid color
///
/// Example:
/// ```dart
/// Container(
///   decoration: DashedDecoration(
///     step: 4,
///     span: 2,
///     strokeWidth: 1,
///     radius: Radius.circular(12),
///     color: Colors.blue,
///   ),
/// )
/// ```
/// {@endtemplate}
class DashedDecoration extends Decoration {
  /// Gradient to apply to the border.
  ///
  /// This overrides the [color] if provided.
  final Gradient? gradient;

  /// Border color. Used only if [gradient] is null.
  final Color? color;

  /// Length of each solid dash segment.
  final double step;

  /// Spacing between each segment or dot.
  final double span;

  /// Number of dots to appear after each dash.
  ///
  /// If greater than 0, draws a dot-dash pattern.
  final int pointCount;

  /// Length of each dot. If null, uses [Paint.strokeWidth].
  final double? pointWidth;

  /// Border radius (corner rounding).
  ///
  /// Defaults to [Radius.zero] if null.
  final Radius? radius;

  /// Thickness of the border.
  final double strokeWidth;

  /// {@macro dashed_decoration}
  const DashedDecoration({
    this.gradient,
    this.color,
    this.step = 2.0,
    this.span = 2.0,
    this.pointCount = 0,
    this.pointWidth,
    this.radius,
    this.strokeWidth = 1.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DashedBoxPainter(this);
  }
}

/// Internal painter for rendering the dashed or dotted border
/// as configured by [DashedDecoration].
class _DashedBoxPainter extends BoxPainter {
  final DashedDecoration decoration;

  _DashedBoxPainter(this.decoration);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final size = config.size;
    if (size == null) return;

    final rect = offset & size;
    final zone = Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height);

    final Radius radius = decoration.radius ?? Radius.zero;

    final path = Path()..addRRect(RRect.fromRectAndRadius(zone, radius));

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = decoration.strokeWidth;

    if (decoration.gradient != null) {
      paint.shader = decoration.gradient!.createShader(zone);
    } else {
      paint.color = decoration.color ?? Colors.black;
    }

    DashedPainter(
      span: decoration.span,
      step: decoration.step,
      pointCount: decoration.pointCount,
      pointWidth: decoration.pointWidth,
    ).paint(canvas, path, paint);
  }
}
