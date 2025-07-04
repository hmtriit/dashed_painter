# 🎨 dashed_painter

[![pub package](https://img.shields.io/pub/v/dashed_painter.svg)](https://pub.dev/packages/dashed_painter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful Flutter plugin to draw dashed lines and shapes on canvas with advanced features including **animation support**, **custom patterns**, and **performance optimization**.

## ✨ Features

### 🎯 Core Features
- Draw dashed lines, circles, rectangles, and complex shapes
- Customizable dash length, spacing, and dot patterns
- Support for gradients and solid colors
- Easy integration with `CustomPainter` and decorations

### 🚀 New in v1.1.0
- **🐜 Animation Support**: Marching ants effect with smooth animations
- **🎨 Custom Dash Patterns**: Define complex patterns with arrays
- **⚡ Performance Optimization**: Intelligent path caching system
- **🎛️ Enhanced API**: New constructors and backward compatibility

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  dashed_painter: ^1.1.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### Basic Usage

```dart
import 'package:dashed_painter/dashed_painter.dart';
import 'package:flutter/material.dart';

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height);

    // Basic dashed line
    const DashedPainter(step: 8, span: 4).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

### 🐜 Animation Support (New!)

Create marching ants effect with smooth animations:

```dart
class AnimatedDashExample extends StatefulWidget {
  @override
  _AnimatedDashExampleState createState() => _AnimatedDashExampleState();
}

class _AnimatedDashExampleState extends State<AnimatedDashExample>
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
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: AnimatedDashPainter(_controller.value * 20),
          size: Size(300, 300),
        );
      },
    );
  }
}

class AnimatedDashPainter extends CustomPainter {
  final double animationOffset;
  
  AnimatedDashPainter(this.animationOffset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.purple
      ..strokeWidth = 3;

    final path = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 200,
        height: 200,
      ));

    DashedPainter(
      step: 8,
      span: 4,
      animationOffset: animationOffset, // ✨ Animation magic!
    ).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(AnimatedDashPainter oldDelegate) {
    return oldDelegate.animationOffset != animationOffset;
  }
}
```

### 🎨 Custom Dash Patterns (New!)

Define complex patterns with arrays:

```dart
class CustomPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.green
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(20, size.height / 2)
      ..lineTo(size.width - 20, size.height / 2);

    // Custom patterns
    DashedPainter.pattern(
      dashPattern: [20, 5, 5, 5, 5, 10], // Morse code-like pattern
    ).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

### 🎛️ Decoration Usage

Use with widgets like `Container`:

```dart
// Basic decoration
Container(
  width: 200,
  height: 100,
  decoration: DashedDecoration(
    step: 6,
    span: 3,
    strokeWidth: 2,
    color: Colors.blue,
    radius: Radius.circular(12),
  ),
  child: Center(child: Text('Dashed Border')),
)

// Animated decoration
Container(
  decoration: DashedDecoration.animated(
    step: 8,
    span: 4,
    animationOffset: animationValue * 15,
    color: Colors.purple,
  ),
  child: Text('Marching Ants Border'),
)

// Custom pattern decoration
Container(
  decoration: DashedDecoration.pattern(
    dashPattern: [12, 6, 3, 6],
    color: Colors.red,
    strokeWidth: 3,
  ),
  child: Text('Custom Pattern Border'),
)
```

## 📖 API Reference

### DashedPainter

#### Constructors

```dart
// Traditional constructor
const DashedPainter({
  double step = 2.0,           // Length of dash segments
  double span = 2.0,           // Space between segments
  int pointCount = 0,          // Number of dots after each dash
  double? pointWidth,          // Width of dots
  double animationOffset = 0.0, // Animation offset
  bool enableCaching = true,   // Enable performance caching
});

// Pattern constructor (New!)
const DashedPainter.pattern({
  required List<double> dashPattern, // Custom pattern array
  double animationOffset = 0.0,
  bool enableCaching = true,
});
```

#### Static Methods

```dart
// Cache management
DashedPainter.clearCache();    // Clear all cached paths
int cacheSize = DashedPainter.cacheSize; // Get cache size
```

### DashedDecoration

#### Constructors

```dart
// Basic constructor
const DashedDecoration({
  Color? color,
  Gradient? gradient,
  double step = 2.0,
  double span = 2.0,
  int pointCount = 0,
  double? pointWidth,
  Radius? radius,
  double strokeWidth = 1.0,
  double animationOffset = 0.0,
  bool enableCaching = true,
});

// Animated constructor (New!)
const DashedDecoration.animated({
  required double animationOffset,
  // ... other parameters
});

// Pattern constructor (New!)
const DashedDecoration.pattern({
  required List<double> dashPattern,
  // ... other parameters
});
```

## 🎨 Pattern Examples

### Pre-defined Patterns

```dart
// Morse code pattern
DashedPainter.pattern(dashPattern: [8, 4, 2, 4, 8, 4, 2, 4])

// Railroad pattern  
DashedPainter.pattern(dashPattern: [12, 6, 3, 6])

// Heartbeat pattern
DashedPainter.pattern(dashPattern: [20, 3, 5, 3, 5, 15])

// Staircase pattern
DashedPainter.pattern(dashPattern: [2, 2, 4, 2, 6, 2, 8, 2])
```

## ⚡ Performance Tips

1. **Enable Caching**: Keep `enableCaching: true` for repeated patterns
2. **Clear Cache**: Call `DashedPainter.clearCache()` when memory is needed
3. **Monitor Cache**: Use `DashedPainter.cacheSize` to monitor cache usage
4. **Animation Optimization**: Use consistent animation timing for best performance

## 📱 Example App

The package includes a comprehensive example app showcasing:
- Basic shape demonstrations
- Animation effects
- Custom pattern gallery  
- Performance comparisons

Run the example:

```bash
cd example
flutter run
```

## 🔄 Migration from v1.0.x

The v1.1.0 release is **fully backward compatible**. Your existing code will work unchanged, and you can gradually adopt new features:

```dart
// v1.0.x code still works
const DashedPainter(step: 4, span: 2);

// v1.1.0 enhanced with animation
const DashedPainter(step: 4, span: 2, animationOffset: animValue);

// v1.1.0 with custom patterns
const DashedPainter.pattern(dashPattern: [8, 4, 2, 4]);
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community contributors and issue reporters
- Inspired by various design tools and drawing libraries

---

Made with ❤️ for the Flutter community
