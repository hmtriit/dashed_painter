import 'package:flutter/material.dart';

import 'benchmark_painter.dart';

class BenchmarkScreen extends StatelessWidget {
  const BenchmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DashPainter Benchmark')),
      body: CustomPaint(
        size: Size.infinite,
        painter: BenchmarkPainter(lineCount: 200),
      ),
    );
  }
}
