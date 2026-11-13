import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_image.dart';

/// Ruta de la tienda (derecha) al cliente (pin izquierdo), en el espacio
/// de dibujo de 440 × 560 del mapa.
const List<Offset> kRoutePoints = [
  Offset(352, 238),
  Offset(352, 262),
  Offset(320, 262),
  Offset(300, 330),
  Offset(262, 352),
  Offset(244, 322),
  Offset(222, 300),
  Offset(196, 276),
  Offset(178, 258),
  Offset(168, 262),
  Offset(150, 244),
  Offset(120, 234),
  Offset(96, 252),
  Offset(88, 258),
];

Path _buildRoute() {
  final path = Path()..moveTo(kRoutePoints.first.dx, kRoutePoints.first.dy);
  for (final p in kRoutePoints.skip(1)) {
    path.lineTo(p.dx, p.dy);
  }
  return path;
}

final Path _route = _buildRoute();
final PathMetric _metric = _route.computeMetrics().first;

/// El repartidor parte del 42 % de la ruta.
const double kRouteStart = 0.42;

double routeFraction(double progress) =>
    kRouteStart + (1 - kRouteStart) * progress;

const String _storePin =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="-20 -38 40 46" '
    'width="40" height="46"><path d="M0 -36a18 18 0 0 1 18 18c0 12-18 24-18 '
    '24s-18-12-18-24a18 18 0 0 1 18-18z" fill="#fff" stroke="#E2E2E2"/>'
    '<rect x="-7" y="-25" width="14" height="10" rx="1.5" fill="#1C1C1E"/>'
    '<path d="M-7 -22h14" stroke="#fff" stroke-width="1.2"/></svg>';

const String _customerPin =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="-20 -40 40 48" '
    'width="40" height="48"><path d="M0 -40a20 20 0 0 1 20 20c0 14-20 28-20 '
    '28s-20-14-20-28a20 20 0 0 1 20-20z" fill="#F26A1D"/>'
    '<circle cy="-20" r="7" fill="#fff"/></svg>';

/// Mapa dibujado (mismo dibujo que el prototipo) con ruta recorrida,
/// repartidor y burbuja de tiempo.
class TrackMap extends StatelessWidget {
  const TrackMap({
    super.key,
    required this.progress,
    required this.minutes,
    required this.courierVisible,
  });

  final double progress;
  final int minutes;
  final bool courierVisible;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 560,
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: 440,
          height: 560,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const AppImage('map_track', width: 440, height: 560),
              ..._labels(),
              CustomPaint(
                size: const Size(440, 560),
                painter: _RoutePainter(routeFraction(progress)),
              ),
              Positioned(
                left: 352 - 20,
                top: 228 - 38,
                child: SvgPicture.string(_storePin, width: 40, height: 46),
              ),
              Positioned(
                left: 80 - 20,
                top: 236 - 40,
                child: SvgPicture.string(_customerPin, width: 40, height: 48),
              ),
              CustomPaint(
                size: const Size(440, 560),
                painter: _CourierPainter(routeFraction(progress)),
              ),
              if (courierVisible)
                _Bubble(f: routeFraction(progress), minutes: minutes),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _label(
    double x,
    double y,
    double size,
    String text, {
    Color color = AppColors.mapLabel,
  }) {
    return Positioned(
      left: x - 100,
      width: 200,
      top: y - size * 0.8,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.of(
          size,
          FontWeight.w600,
          color: color,
        ).copyWith(height: 1),
      ),
    );
  }

  static Widget _badge(
    double x,
    double y,
    double w,
    String text,
    Color border,
    Color fg,
  ) {
    return Positioned(
      left: x - w / 2,
      top: y - 7,
      width: w,
      height: 14,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: border),
        ),
        child: Text(
          text,
          style: AppTypography.of(
            9,
            FontWeight.w700,
            color: fg,
          ).copyWith(height: 1),
        ),
      ),
    );
  }

  List<Widget> _labels() {
    return [
      _label(70, 148, 14, 'الدرعية'),
      _label(70, 166, 13, "Al Deri'yya"),
      _label(380, 300, 10, 'جامعة الملك سعود', color: AppColors.mapLabelGreen),
      _label(
        380,
        313,
        10,
        'King Saud University',
        color: AppColors.mapLabelGreen,
      ),
      _label(60, 400, 11, 'الدرعية الجديدة'),
      _label(60, 414, 11, 'Al Deriyah Al Jadeedah'),
      _label(370, 440, 11, 'الخزامى'),
      _label(370, 454, 11, 'Al Khozami'),
      _badge(
        250,
        150,
        18,
        '40',
        AppColors.mapBadgeStroke,
        AppColors.mapBadgeText,
      ),
      _badge(
        272,
        400,
        26,
        'M80',
        AppColors.mapBadgeStroke2,
        AppColors.mapBadgeText2,
      ),
    ];
  }
}

class _RoutePainter extends CustomPainter {
  _RoutePainter(this.fraction);

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    Paint stroke(Color c) =>
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;
    canvas.drawPath(_route, stroke(AppColors.routeGrey));
    canvas.drawPath(
      _metric.extractPath(0, _metric.length * fraction),
      stroke(AppColors.primary),
    );
  }

  @override
  bool shouldRepaint(_RoutePainter old) => old.fraction != fraction;
}

Offset _pointAt(double fraction) =>
    _metric.getTangentForOffset(_metric.length * fraction)!.position;

class _CourierPainter extends CustomPainter {
  _CourierPainter(this.fraction);

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final p = _pointAt(fraction);
    canvas.drawCircle(p, 9, Paint()..color = AppColors.primary);
    canvas.drawCircle(
      p,
      9,
      Paint()
        ..color = AppColors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5,
    );
  }

  @override
  bool shouldRepaint(_CourierPainter old) => old.fraction != fraction;
}

/// Burbuja blanca de 76 × 30 con el camión y los minutos.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.f, required this.minutes});

  final double f;
  final int minutes;

  @override
  Widget build(BuildContext context) {
    final p = _pointAt(f);
    return Positioned(
      left: p.dx - 38,
      top: p.dy - 46,
      width: 76,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.bubbleStroke),
        ),
        child: Stack(
          children: [
            const Positioned(
              left: 9,
              top: 5,
              child: AppImage('service_truck', width: 19.2, height: 19.2),
            ),
            Positioned(
              left: 50 - 30,
              width: 60,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  '$minutes min',
                  maxLines: 1,
                  softWrap: false,
                  style: AppTypography.of(
                    13,
                    FontWeight.w700,
                  ).copyWith(height: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Punto fijo usado por pruebas y capturas.
Offset routePointAt(double fraction) => _pointAt(fraction);
