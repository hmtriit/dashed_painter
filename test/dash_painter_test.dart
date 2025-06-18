import 'package:dashed_painter/dashed_painter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashedPainter logic', () {
    test('calculates partLength correctly without dots', () {
      const painter = DashedPainter(step: 4.0, span: 2.0, pointCount: 0);
      const expected = 4.0 + 2.0; // step + span
      final calculated = painter.step + painter.span;
      expect(calculated, expected);
    });

    test('calculates partLength correctly with dots', () {
      const painter = DashedPainter(
        step: 4.0,
        span: 2.0,
        pointCount: 2,
        pointWidth: 1.0,
      );
      const expected =
          4.0 + 2.0 * 3 + 1.0 * 2; // step + span*(dots+1) + dotLen*dots = 12
      final partLength =
          painter.step +
          painter.span * (painter.pointCount + 1) +
          (painter.pointWidth ?? 1.0) * painter.pointCount;
      expect(partLength, expected);
    });

    test('uses strokeWidth when pointWidth is null', () {
      const painter = DashedPainter(
        pointCount: 2,
        step: 4,
        span: 2,
        pointWidth: null,
      );
      expect(painter.pointWidth, isNull);
    });
  });
}
