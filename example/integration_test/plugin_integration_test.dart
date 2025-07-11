// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter/material.dart';
import 'package:flutter_dashed_painter_example/benchmark_painter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('BenchmarkPainter renders without crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomPaint(painter: BenchmarkPainter(lineCount: 500)),
        ),
      ),
    );

    // Ensure no exceptions and widget built
    expect(find.byType(CustomPaint), findsOneWidget);
  });
}
