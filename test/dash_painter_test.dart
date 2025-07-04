import 'package:dashed_painter/dashed_painter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('DashedPainter Tests', () {
    test('should create DashedPainter with default values', () {
      const painter = DashedPainter();

      expect(painter.step, 2.0);
      expect(painter.span, 2.0);
      expect(painter.pointCount, 0);
      expect(painter.pointWidth, null);
      expect(painter.animationOffset, 0.0);
      expect(painter.enableCaching, true);
      expect(painter.dashPattern, null);
    });

    test('should create DashedPainter with custom values', () {
      const painter = DashedPainter(
        step: 5.0,
        span: 3.0,
        pointCount: 2,
        pointWidth: 1.5,
        animationOffset: 10.0,
        enableCaching: false,
      );

      expect(painter.step, 5.0);
      expect(painter.span, 3.0);
      expect(painter.pointCount, 2);
      expect(painter.pointWidth, 1.5);
      expect(painter.animationOffset, 10.0);
      expect(painter.enableCaching, false);
    });

    test('should create DashedPainter with custom pattern', () {
      const pattern = [8.0, 4.0, 2.0, 4.0];
      const painter = DashedPainter.pattern(
        dashPattern: pattern,
        animationOffset: 5.0,
        enableCaching: true,
      );

      expect(painter.dashPattern, pattern);
      expect(painter.animationOffset, 5.0);
      expect(painter.enableCaching, true);
      expect(painter.step, 0.0);
      expect(painter.span, 0.0);
      expect(painter.pointCount, 0);
    });

    test('should manage cache correctly', () {
      // Clear cache first
      DashedPainter.clearCache();
      expect(DashedPainter.cacheSize, 0);

      // Note: Cache is populated during paint operations,
      // so we can't test actual cache population without a full render context
      // But we can test the static methods
      DashedPainter.clearCache();
      expect(DashedPainter.cacheSize, 0);
    });
  });

  group('DashedDecoration Tests', () {
    test('should create DashedDecoration with default values', () {
      const decoration = DashedDecoration();

      expect(decoration.step, 2.0);
      expect(decoration.span, 2.0);
      expect(decoration.pointCount, 0);
      expect(decoration.strokeWidth, 1.0);
      expect(decoration.animationOffset, 0.0);
      expect(decoration.enableCaching, true);
      expect(decoration.dashPattern, null);
    });

    test('should create animated DashedDecoration', () {
      const decoration = DashedDecoration.animated(
        animationOffset: 15.0,
        step: 4.0,
        span: 2.0,
        color: Colors.blue,
      );

      expect(decoration.animationOffset, 15.0);
      expect(decoration.step, 4.0);
      expect(decoration.span, 2.0);
      expect(decoration.color, Colors.blue);
      expect(decoration.dashPattern, null);
    });

    test('should create pattern DashedDecoration', () {
      const pattern = [10.0, 5.0, 3.0, 5.0];
      const decoration = DashedDecoration.pattern(
        dashPattern: pattern,
        color: Colors.red,
        strokeWidth: 2.0,
      );

      expect(decoration.dashPattern, pattern);
      expect(decoration.color, Colors.red);
      expect(decoration.strokeWidth, 2.0);
      expect(decoration.step, 0.0);
      expect(decoration.span, 0.0);
    });

    test('should create BoxPainter', () {
      const decoration = DashedDecoration();
      final painter = decoration.createBoxPainter();

      expect(painter, isNotNull);
    });

    test('should implement equality correctly', () {
      const decoration1 = DashedDecoration(
        step: 4.0,
        span: 2.0,
        color: Colors.blue,
        animationOffset: 5.0,
      );

      const decoration2 = DashedDecoration(
        step: 4.0,
        span: 2.0,
        color: Colors.blue,
        animationOffset: 5.0,
      );

      const decoration3 = DashedDecoration(
        step: 4.0,
        span: 3.0, // Different span
        color: Colors.blue,
        animationOffset: 5.0,
      );

      expect(decoration1, equals(decoration2));
      expect(decoration1, isNot(equals(decoration3)));
      expect(decoration1.hashCode, equals(decoration2.hashCode));
      expect(decoration1.hashCode, isNot(equals(decoration3.hashCode)));
    });

    test('should handle pattern equality correctly', () {
      const pattern1 = [5.0, 3.0, 2.0, 3.0];
      const pattern2 = [5.0, 3.0, 2.0, 3.0];
      const pattern3 = [5.0, 3.0, 2.0, 4.0]; // Different pattern

      const decoration1 = DashedDecoration.pattern(
        dashPattern: pattern1,
        color: Colors.green,
      );

      const decoration2 = DashedDecoration.pattern(
        dashPattern: pattern2,
        color: Colors.green,
      );

      const decoration3 = DashedDecoration.pattern(
        dashPattern: pattern3,
        color: Colors.green,
      );

      expect(decoration1, equals(decoration2));
      expect(decoration1, isNot(equals(decoration3)));
    });
  });

  group('Performance and Edge Cases', () {
    test('should handle empty dash pattern gracefully', () {
      const painter = DashedPainter.pattern(dashPattern: []);

      expect(painter.dashPattern, isEmpty);
      // The painter should not crash when painting with empty pattern
      // (actual paint testing would require flutter_test environment)
    });

    test('should handle zero animation offset', () {
      const painter = DashedPainter(animationOffset: 0.0);

      expect(painter.animationOffset, 0.0);
      // Zero offset should work as non-animated painting
    });

    test('should handle negative animation offset', () {
      const painter = DashedPainter(animationOffset: -10.0);

      expect(painter.animationOffset, -10.0);
      // Negative offsets should be handled properly in animation logic
    });

    test('should handle large animation offset', () {
      const painter = DashedPainter(animationOffset: 1000.0);

      expect(painter.animationOffset, 1000.0);
      // Large offsets should be normalized through modulo operations
    });

    test('should handle caching toggle', () {
      const painter1 = DashedPainter(enableCaching: true);
      const painter2 = DashedPainter(enableCaching: false);

      expect(painter1.enableCaching, true);
      expect(painter2.enableCaching, false);
    });
  });

  group('Backward Compatibility', () {
    test('should maintain compatibility with v1.0.x API', () {
      // Test that old API still works
      const oldStylePainter = DashedPainter(
        step: 4.0,
        span: 2.0,
        pointCount: 1,
        pointWidth: 1.0,
      );

      expect(oldStylePainter.step, 4.0);
      expect(oldStylePainter.span, 2.0);
      expect(oldStylePainter.pointCount, 1);
      expect(oldStylePainter.pointWidth, 1.0);

      const oldStyleDecoration = DashedDecoration(
        step: 4.0,
        span: 2.0,
        strokeWidth: 1.0,
        color: Colors.blue,
      );

      expect(oldStyleDecoration.step, 4.0);
      expect(oldStyleDecoration.span, 2.0);
      expect(oldStyleDecoration.strokeWidth, 1.0);
      expect(oldStyleDecoration.color, Colors.blue);
    });
  });
}
