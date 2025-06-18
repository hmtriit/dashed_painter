import 'package:dash_painter/dash_painter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dash Painter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Center(
          child: CustomPaint(
            size: Size(400, 400),
            painter: DashRoundedRectPainter(),
          ),
        ),
      ),
    );
  }
}

// 🧱 1. DashHorizontalLinePainter – Vẽ đường ngang nét đứt
class DashHorizontalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.orangeAccent
          ..strokeWidth = 1;

    final path =
        Path()
          ..moveTo(-200, 0)
          ..lineTo(200, 0);

    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🧱 2. DashVerticalLinePainter – Vẽ đường dọc nét đứt
class DashVerticalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.orangeAccent
          ..strokeWidth = 1;

    final path =
        Path()
          ..moveTo(0, -200)
          ..lineTo(0, 200);

    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🧱 3. DashCirclePainter – Vẽ hình tròn nét đứt
class DashCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.orangeAccent
          ..strokeWidth = 1;

    final path =
        Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: 80));

    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🧱 4. DashRoundedRectPainter – Vẽ hình chữ nhật bo góc nét đứt
class DashRoundedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.orangeAccent
          ..strokeWidth = 1;

    final path =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCircle(center: Offset.zero, radius: 100),
            Radius.circular(20),
          ),
        );

    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 🧱 5. DashedGeometryPainter – Vẽ hình học nét đứt
class DashedGeometryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    Paint paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.orangeAccent
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
    const DashPainter(span: 4, step: 9).paint(canvas, path, paint);
  }

  @override
  bool shouldRepaint(covariant DashedGeometryPainter oldDelegate) => false;
}
