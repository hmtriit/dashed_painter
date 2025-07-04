import 'package:dashed_painter/dashed_painter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// start benchmark
    //return const MaterialApp(home: BenchmarkScreen());
    /// end benchmark

    /// start demo
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dash Painter Demo v1.1.0',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BasicDemoScreen(),
    const AnimationDemoScreen(),
    const PatternDemoScreen(),
    const PerformanceDemoScreen(),
  ];

  final List<String> _titles = [
    'Basic Shapes',
    'Animation Demo',
    'Custom Patterns',
    'Performance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Basic'),
          BottomNavigationBarItem(
            icon: Icon(Icons.animation),
            label: 'Animation',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.pattern), label: 'Patterns'),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Performance',
          ),
        ],
      ),
    );
  }
}

// 🎨 Basic Demo Screen - Traditional dashed shapes
class BasicDemoScreen extends StatelessWidget {
  const BasicDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(400, 400),
        painter: DashedGeometryPainter(),
      ),
    );
  }
}

// ✨ Animation Demo Screen - Marching ants effects
class AnimationDemoScreen extends StatefulWidget {
  const AnimationDemoScreen({super.key});

  @override
  State<AnimationDemoScreen> createState() => _AnimationDemoScreenState();
}

class _AnimationDemoScreenState extends State<AnimationDemoScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '🐜 Marching Ants Effect',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(350, 350),
                  painter: AnimatedDashPainter(_controller.value * 20),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _controller.repeat(),
                child: const Text('Start'),
              ),
              ElevatedButton(
                onPressed: () => _controller.stop(),
                child: const Text('Stop'),
              ),
              ElevatedButton(
                onPressed: () => _controller.reset(),
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 🎭 Pattern Demo Screen - Custom dash patterns
class PatternDemoScreen extends StatelessWidget {
  const PatternDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '🎨 Custom Dash Patterns',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildPatternCard('Morse Code', [8, 4, 2, 4, 8, 4, 2, 4]),
              _buildPatternCard('Railroad', [12, 6, 3, 6]),
              _buildPatternCard('Heartbeat', [20, 3, 5, 3, 5, 15]),
              _buildPatternCard('Stairs', [2, 2, 4, 2, 6, 2, 8, 2]),
              _buildPatternCard('Musical', [10, 5, 3, 5, 3, 5, 10, 15]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPatternCard(String name, List<double> pattern) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pattern: [${pattern.join(', ')}]',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            CustomPaint(
              size: const Size(double.infinity, 40),
              painter: PatternDemoPainter(pattern),
            ),
          ],
        ),
      ),
    );
  }
}

// ⚡ Performance Demo Screen - Caching demonstration
class PerformanceDemoScreen extends StatefulWidget {
  const PerformanceDemoScreen({super.key});

  @override
  State<PerformanceDemoScreen> createState() => _PerformanceDemoScreenState();
}

class _PerformanceDemoScreenState extends State<PerformanceDemoScreen> {
  bool _enableCaching = true;
  int _shapeCount = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '⚡ Performance Optimization',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Enable Caching:'),
                    Switch(
                      value: _enableCaching,
                      onChanged: (value) {
                        setState(() {
                          _enableCaching = value;
                          if (!value) DashedPainter.clearCache();
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Shape Count:'), Text('$_shapeCount')],
                ),
                Slider(
                  value: _shapeCount.toDouble(),
                  min: 10,
                  max: 200,
                  divisions: 19,
                  onChanged: (value) {
                    setState(() {
                      _shapeCount = value.round();
                    });
                  },
                ),
                Text('Cache Size: ${DashedPainter.cacheSize}'),
                ElevatedButton(
                  onPressed: () {
                    DashedPainter.clearCache();
                    setState(() {});
                  },
                  child: const Text('Clear Cache'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: PerformanceDemoPainter(_shapeCount, _enableCaching),
          ),
        ),
      ],
    );
  }
}

// 🧱 Original Painters (kept for compatibility)

class DashedGeometryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    Paint paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.blue
          ..strokeWidth = 1;

    final Path path = Path();
    path.moveTo(-200, 0);
    path.lineTo(200, 0);
    path.moveTo(0, -200);
    path.lineTo(0, 200);

    path.addOval(Rect.fromCircle(center: Offset.zero, radius: 80));
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCircle(center: Offset.zero, radius: 100),
        Radius.circular(20),
      ),
    );
    const DashedPainter(span: 4, step: 9).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(covariant DashedGeometryPainter oldDelegate) => false;
}

// 🎬 New v1.1.0 Painters

class AnimatedDashPainter extends CustomPainter {
  final double animationOffset;

  AnimatedDashPainter(this.animationOffset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.purple
          ..strokeWidth = 3;

    // Animated circle
    final circlePath =
        Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: 80));
    DashedPainter(
      step: 8,
      span: 4,
      animationOffset: animationOffset,
    ).paint(canvas, circlePath, paint);

    // Animated square
    paint.color = Colors.green;
    final squarePath =
        Path()..addRect(
          Rect.fromCenter(center: Offset.zero, width: 120, height: 120),
        );
    DashedPainter(
      step: 6,
      span: 3,
      animationOffset: -animationOffset * 1.5, // Reverse direction
    ).paint(canvas, squarePath, paint);

    // Animated heart shape
    paint.color = Colors.red;
    final heartPath = _createHeartPath();
    DashedPainter.pattern(
      dashPattern: [10, 5, 3, 5],
      animationOffset: animationOffset * 0.8,
    ).paint(canvas, heartPath, paint);
  }

  Path _createHeartPath() {
    final path = Path();
    path.moveTo(0, 20);
    path.cubicTo(-40, -20, -80, 10, 0, 60);
    path.cubicTo(80, 10, 40, -20, 0, 20);
    return path;
  }

  @override
  bool shouldRepaint(AnimatedDashPainter oldDelegate) {
    return oldDelegate.animationOffset != animationOffset;
  }
}

class PatternDemoPainter extends CustomPainter {
  final List<double> pattern;

  PatternDemoPainter(this.pattern);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.blue
          ..strokeWidth = 3;

    final path =
        Path()
          ..moveTo(20, size.height / 2)
          ..lineTo(size.width - 20, size.height / 2);

    DashedPainter.pattern(dashPattern: pattern).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(PatternDemoPainter oldDelegate) {
    return oldDelegate.pattern != pattern;
  }
}

class PerformanceDemoPainter extends CustomPainter {
  final int shapeCount;
  final bool enableCaching;

  PerformanceDemoPainter(this.shapeCount, this.enableCaching);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    for (int i = 0; i < shapeCount; i++) {
      final double x = (i % 10) * (size.width / 10) + 20;
      final double y = (i ~/ 10) * 40 + 40;
      final double radius = 15 + (i % 3) * 5;

      paint.color = Colors.primaries[i % Colors.primaries.length];

      final path =
          Path()
            ..addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));

      DashedPainter(
        step: 4,
        span: 2,
        enableCaching: enableCaching,
      ).paint(canvas, path, paint);
    }
  }

  @override
  bool shouldRepaint(PerformanceDemoPainter oldDelegate) {
    return oldDelegate.shapeCount != shapeCount ||
        oldDelegate.enableCaching != enableCaching;
  }
}
