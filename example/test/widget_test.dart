// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_dashed_painter_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Verify that dashed line is drawn via CustomPaint', (
    WidgetTester tester,
  ) async {
    // start app
    await tester.pumpWidget(MyApp());

    // find CustomPaint widget
    final paintFinder = find.byWidgetPredicate(
      (widget) => widget is CustomPaint,
    );

    // verify that there is at least one CustomPaint widget
    expect(paintFinder, findsAtLeastNWidgets(1));

    // verify that there is a CustomPaint widget with BenchmarkPainter
    // final benchmarkFinder = find.byWidgetPredicate(
    //   (widget) => widget is CustomPaint && widget.painter is BenchmarkPainter,
    // );
    // expect(benchmarkFinder, findsOneWidget);
  });
}
