import 'dart:ui';

export 'dashed_decoration.dart';

/// {@template dashed_painter}
/// A utility to draw dashed or dotted paths using a `Canvas`.
///
/// Supports both solid dash lines and dot-dash patterns.
/// You can control spacing, dash length, and dot count/width.
///
/// New in v1.1.0:
/// - Animation support with marching ants effect
/// - Custom dash patterns with arrays
/// - Performance optimization with path caching
///
/// Typical use case is inside `CustomPainter` or custom `Decoration`.
///
/// ```dart
/// final path = Path()..moveTo(0, 0)..lineTo(100, 0);
/// DashedPainter(step: 4, span: 2).paint(canvas, path, paint);
///
/// // With animation
/// DashedPainter(
///   step: 4,
///   span: 2,
///   animationOffset: animationValue * 10,
/// ).paint(canvas, path, paint);
///
/// // With custom pattern
/// DashedPainter.pattern(
///   dashPattern: [5, 3, 2, 3],
/// ).paint(canvas, path, paint);
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

  /// Custom dash pattern array. If provided, overrides step/span/pointCount.
  /// Array represents alternating dash lengths and gaps.
  /// Example: [5, 3, 2, 3] = 5px dash, 3px gap, 2px dash, 3px gap, repeat.
  final List<double>? dashPattern;

  /// Animation offset for marching ants effect.
  /// Use with AnimationController to create moving dashes.
  /// Value represents the offset distance of the entire pattern.
  final double animationOffset;

  /// Enable path caching for performance optimization.
  /// When true, computed path segments are cached for reuse.
  final bool enableCaching;

  /// Internal cache for computed path segments
  static final Map<String, List<Path>> _pathCache = {};

  /// Creates a new dashed painter with the given dash configuration.
  const DashedPainter({
    this.step = 2.0,
    this.span = 2.0,
    this.pointCount = 0,
    this.pointWidth,
    this.animationOffset = 0.0,
    this.enableCaching = true,
  }) : dashPattern = null;

  /// Creates a dashed painter with a custom dash pattern.
  ///
  /// [dashPattern] should contain alternating dash and gap lengths.
  /// Example: [5, 3, 2, 3] creates a pattern of 5px dash, 3px gap, 2px dash, 3px gap.
  const DashedPainter.pattern({
    required this.dashPattern,
    this.animationOffset = 0.0,
    this.enableCaching = true,
  }) : step = 0.0,
       span = 0.0,
       pointCount = 0,
       pointWidth = null;

  /// Gets the effective dash pattern to use for rendering.
  List<double> _getEffectiveDashPattern() {
    if (dashPattern != null && dashPattern!.isNotEmpty) {
      return dashPattern!;
    }

    // Convert traditional step/span/points to pattern array
    if (pointCount > 0) {
      final double dotLength = pointWidth ?? 1.0;
      final List<double> pattern = [step];

      for (int i = 0; i < pointCount; i++) {
        pattern.addAll([span, dotLength]);
      }
      pattern.add(span); // Final gap
      return pattern;
    }

    return [step, span];
  }

  /// Generates a cache key for the given parameters.
  String _generateCacheKey(Path path, List<double> pattern, double pathLength) {
    if (!enableCaching) return '';

    final pathHash = path.computeMetrics().map((m) => m.length).join(',');
    final patternString = pattern.join(',');
    return '$pathHash-$patternString-$pathLength';
  }

  /// Paints the dashed path to the provided canvas using the given path and paint.
  void paint(Canvas canvas, Path path, Paint paint) {
    final PathMetrics metrics = path.computeMetrics();
    final List<double> pattern = _getEffectiveDashPattern();

    if (pattern.isEmpty) {
      canvas.drawPath(path, paint);
      return;
    }

    final double patternLength = pattern.fold(
      0.0,
      (sum, length) => sum + length,
    );

    for (final PathMetric pm in metrics) {
      final double pathLength = pm.length;
      if (pathLength == 0) continue;

      final String cacheKey = _generateCacheKey(path, pattern, pathLength);
      List<Path>? cachedPaths;

      if (enableCaching && cacheKey.isNotEmpty) {
        cachedPaths = _pathCache[cacheKey];
      }

      if (cachedPaths != null) {
        // Use cached paths with animation offset
        _drawCachedPaths(canvas, cachedPaths, paint, pm, patternLength);
      } else {
        // Compute and optionally cache new paths
        final paths = _computeDashPaths(pm, pattern, patternLength, pathLength);

        if (enableCaching && cacheKey.isNotEmpty) {
          _pathCache[cacheKey] = paths;
        }

        _drawCachedPaths(canvas, paths, paint, pm, patternLength);
      }
    }
  }

  /// Computes dash paths for the given path metric and pattern.
  List<Path> _computeDashPaths(
    PathMetric pm,
    List<double> pattern,
    double patternLength,
    double pathLength,
  ) {
    final List<Path> paths = [];
    double currentDistance = 0.0;
    int patternIndex = 0;
    bool isDash = true;

    while (currentDistance < pathLength) {
      final double segmentLength = pattern[patternIndex % pattern.length];
      final double segmentEnd = (currentDistance + segmentLength).clamp(
        0.0,
        pathLength,
      );

      if (isDash && segmentEnd > currentDistance) {
        final extractedPath = pm.extractPath(currentDistance, segmentEnd);
        paths.add(extractedPath);
      }

      currentDistance = segmentEnd;
      patternIndex++;
      isDash = !isDash;

      if (currentDistance >= pathLength) break;
    }

    return paths;
  }

  /// Draws cached paths with animation offset applied.
  void _drawCachedPaths(
    Canvas canvas,
    List<Path> paths,
    Paint paint,
    PathMetric pm,
    double patternLength,
  ) {
    if (animationOffset == 0.0) {
      // No animation, draw directly
      for (final path in paths) {
        canvas.drawPath(path, paint);
      }
      return;
    }

    // Apply animation offset
    final double pathLength = pm.length;
    final double normalizedOffset =
        (animationOffset % patternLength) / patternLength;
    final double offsetDistance = normalizedOffset * pathLength;

    canvas.save();

    // Create animated paths by shifting the pattern
    for (final path in paths) {
      final PathMetrics pathMetrics = path.computeMetrics();
      for (final PathMetric pathMetric in pathMetrics) {
        final double startOffset = offsetDistance;
        final double endOffset =
            (offsetDistance + pathMetric.length) % pathLength;

        if (endOffset > startOffset) {
          final animatedPath = pm.extractPath(startOffset, endOffset);
          canvas.drawPath(animatedPath, paint);
        } else {
          // Handle wrap-around
          final path1 = pm.extractPath(startOffset, pathLength);
          final path2 = pm.extractPath(0, endOffset);
          canvas.drawPath(path1, paint);
          canvas.drawPath(path2, paint);
        }
      }
    }

    canvas.restore();
  }

  /// Clears the internal path cache to free memory.
  static void clearCache() {
    _pathCache.clear();
  }

  /// Gets the current cache size (number of cached path sets).
  static int get cacheSize => _pathCache.length;
}
