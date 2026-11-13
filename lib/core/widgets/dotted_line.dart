import 'package:flutter/material.dart';

/// Línea punteada como el `border-top: 2.5px dotted` del HTML.
class DottedLine extends StatelessWidget {
  const DottedLine({super.key, required this.color, this.thickness = 2.5});

  final Color color;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedPainter(color, thickness),
      size: Size(double.infinity, thickness),
    );
  }
}

class _DottedPainter extends CustomPainter {
  _DottedPainter(this.color, this.thickness);

  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final r = thickness / 2;
    final step = thickness * 2;
    var x = r;
    while (x <= size.width - r + 0.01) {
      canvas.drawCircle(Offset(x, r), r, paint);
      x += step;
    }
  }

  @override
  bool shouldRepaint(_DottedPainter old) =>
      old.color != color || old.thickness != thickness;
}
