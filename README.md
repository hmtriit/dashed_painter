# 🖌️ dashed_painter

`dashed_painter` is a Flutter plugin that helps you easily draw **dashed lines** and **dot-dash patterns** on a `Canvas`.  
Ideal for use in `CustomPainter`, `Decoration`, or anywhere a `Canvas` is used.

---

## 🚀 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  dashed_painter: ^1.0.0
```

```bash
flutter pub add dashed_painter

```

## 🎨 Usage

1. Drawing with CustomPainter

```dart
class MyDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    const DashedPainter(span: 4, step: 8).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
```

2. Drawing with DashedDecoration (BoxDecoration-like)

```dart
Container(
  width: 200,
  height: 200,
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.blue,
      width: 2,
    ),
    borderRadius: BorderRadius.circular(20),
    decoration: const DashedDecoration(
      span: 4,
      step: 8,
    ),
  ),
)
```

You can also use gradients:

```dart
decoration: DashedDecoration(
  step: 6,
  span: 3,
  strokeWidth: 1.5,
  radius: Radius.circular(12),
  gradient: SweepGradient(colors: [Colors.red, Colors.green, Colors.blue]),
),

```

✨ Features

✅ Draw solid dashed lines

✅ Draw dot-dash patterns

✅ Supports drawing on arbitrary shapes and complex paths

✅ Fully customizable step, span, and dot details

✅ Works with Canvas or BoxDecoration

✅ Gradient support via DashedDecoration

✅ Lightweight, no custom widget required

🧩 API DashedPainter
| Property | Description | Type | Default |
| ------------ | ----------------------------------------- | --------- | ---------------------------------- |
| `span` | Space between each dash segment | `double` | `4.0` |
| `step` | Length of each dash segment | `double` | `9.0` |
| `pointCount` | Number of dots per segment (for dot-dash) | `int` | `0` |
| `pointWidth` | Length of each dot (if `pointCount > 0`) | `double?` | `null` (falls back to strokeWidth) |

🧱 API DashDecoration
Includes all properties from `DashedPainter`:
| Property | Description | Type |
| ------------- | ------------------------------------------- | ----------- |
| `radius` | Corner radius of the border rectangle | `Radius?` |
| `strokeWidth` | Thickness of the dashed line | `double` |
| `color` | Border color (ignored if `gradient` is set) | `Color?` |
| `gradient` | Border gradient (`SweepGradient`, etc.) | `Gradient?` |

📂 Example Structure

```vpnet
dashed_painter/
├── lib/
│   └── dashed_painter.dart
├── lib/
│   └── dashed_decoration.dart
├── example/
│   └── lib/
│       ├── main.dart
│       └── benchmark_painter.dart
├── test/
│   └── dashed_painter_test.dart
├── README.md
├── LICENSE
└── pubspec.yaml

```

📦 Example

Try the interactive benchmark and decoration examples in the example/ project:

```bash
cd example
flutter run
```

🧪 Testing
Unit tests for internal logic (step/span calculations) are included in /test.

To run:

```bash
flutter test
```

## 📝 License

This project is licensed under the MIT License.
