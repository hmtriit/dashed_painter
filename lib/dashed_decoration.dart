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
/// - Animation support with marching ants effect (v1.1.0)
/// - Custom dash patterns with arrays (v1.1.0)
/// - Performance optimization with path caching (v1.1.0)
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
///
/// // With animation
/// Container(
///   decoration: DashedDecoration.animated(
///     step: 4,
///     span: 2,
///     animationOffset: animationValue * 10,
///     color: Colors.blue,
///   ),
/// )
///
/// // With custom pattern
/// Container(
///   decoration: DashedDecoration.pattern(
///     dashPattern: [8, 4, 2, 4],
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

  /// Custom dash pattern array. If provided, overrides step/span/pointCount.
  /// Array represents alternating dash lengths and gaps.
  final List<double>? dashPattern;

  /// Animation offset for marching ants effect.
  final double animationOffset;

  /// Enable path caching for performance optimization.
  final bool enableCaching;

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
    this.animationOffset = 0.0,
    this.enableCaching = true,
  }) : dashPattern = null;

  /// Creates an animated dashed decoration with marching ants effect.
  const DashedDecoration.animated({
    this.gradient,
    this.color,
    this.step = 2.0,
    this.span = 2.0,
    this.pointCount = 0,
    this.pointWidth,
    this.radius,
    this.strokeWidth = 1.0,
    required this.animationOffset,
    this.enableCaching = true,
  }) : dashPattern = null;

  /// Creates a dashed decoration with a custom dash pattern.
  const DashedDecoration.pattern({
    this.gradient,
    this.color,
    required this.dashPattern,
    this.radius,
    this.strokeWidth = 1.0,
    this.animationOffset = 0.0,
    this.enableCaching = true,
  }) : step = 0.0,
       span = 0.0,
       pointCount = 0,
       pointWidth = null;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DashedBoxPainter(this, onChanged);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is DashedDecoration &&
        other.gradient == gradient &&
        other.color == color &&
        other.step == step &&
        other.span == span &&
        other.pointCount == pointCount &&
        other.pointWidth == pointWidth &&
        other.dashPattern == dashPattern &&
        other.animationOffset == animationOffset &&
        other.enableCaching == enableCaching &&
        other.radius == radius &&
        other.strokeWidth == strokeWidth;
  }

  @override
  int get hashCode {
    return Object.hash(
      gradient,
      color,
      step,
      span,
      pointCount,
      pointWidth,
      dashPattern,
      animationOffset,
      enableCaching,
      radius,
      strokeWidth,
    );
  }
}

/// Internal painter for rendering the dashed or dotted border
/// as configured by [DashedDecoration].
class _DashedBoxPainter extends BoxPainter {
  final DashedDecoration decoration;

  _DashedBoxPainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

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

    // Use the appropriate DashedPainter constructor based on the decoration
    late final DashedPainter dashedPainter;

    if (decoration.dashPattern != null) {
      dashedPainter = DashedPainter.pattern(
        dashPattern: decoration.dashPattern!,
        animationOffset: decoration.animationOffset,
        enableCaching: decoration.enableCaching,
      );
    } else {
      dashedPainter = DashedPainter(
        span: decoration.span,
        step: decoration.step,
        pointCount: decoration.pointCount,
        pointWidth: decoration.pointWidth,
        animationOffset: decoration.animationOffset,
        enableCaching: decoration.enableCaching,
      );
    }

    dashedPainter.paint(canvas, path, paint);
  }
}
