import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_graphics/vector_graphics.dart' show vg;
import 'package:flutter_svg/flutter_svg.dart' show SvgAssetLoader;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_image.dart';

/// Iconos de los marcadores, dibujados con el mismo diseño del prototipo.
class MapMarkers {
  MapMarkers._();

  static const double _ratio = 3;
  static final Map<String, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> _render(
    String key,
    double w,
    double h,
    void Function(ui.Canvas canvas) draw,
  ) async {
    final cached = _cache[key];
    if (cached != null) return cached;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder)..scale(_ratio);
    draw(canvas);
    final image = await recorder.endRecording().toImage(
      (w * _ratio).ceil(),
      (h * _ratio).ceil(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final icon = BitmapDescriptor.bytes(
      Uint8List.view(bytes!.buffer),
      width: w,
      height: h,
    );
    return _cache[key] = icon;
  }

  /// Pin blanco de la tienda (40 × 46, punta en y = 44).
  static Future<BitmapDescriptor> store() {
    return _render('store', 40, 46, (c) {
      c.translate(20, 38);
      final pin = _pin(18, 12, 24);
      c.drawPath(pin, ui.Paint()..color = AppColors.white);
      c.drawPath(
        pin,
        ui.Paint()
          ..color = AppColors.pinStroke
          ..style = ui.PaintingStyle.stroke,
      );
      c.drawRRect(
        ui.RRect.fromRectAndRadius(
          const ui.Rect.fromLTWH(-7, -25, 14, 10),
          const ui.Radius.circular(1.5),
        ),
        ui.Paint()..color = AppColors.pillDark,
      );
      c.drawLine(
        const ui.Offset(-7, -22),
        const ui.Offset(7, -22),
        ui.Paint()
          ..color = AppColors.white
          ..strokeWidth = 1.2,
      );
    });
  }

  /// Pin naranja del cliente (40 × 48).
  static Future<BitmapDescriptor> customer() {
    return _render('customer', 40, 48, (c) {
      c.translate(20, 40);
      c.drawPath(_pin(20, 14, 28), ui.Paint()..color = AppColors.primary);
      c.drawCircle(
        const ui.Offset(0, -20),
        7,
        ui.Paint()..color = AppColors.white,
      );
    });
  }

  /// Punto del repartidor: relleno naranja de 18 con borde blanco de 3.5.
  static Future<BitmapDescriptor> courier() {
    return _render('courier', 24, 24, (c) {
      const center = ui.Offset(12, 12);
      c.drawCircle(center, 9, ui.Paint()..color = AppColors.primary);
      c.drawCircle(
        center,
        9,
        ui.Paint()
          ..color = AppColors.white
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = 3.5,
      );
    });
  }

  /// Burbuja de 76 × 30 con el camión y los minutos (más 16 de aire debajo).
  static Future<BitmapDescriptor> bubble(int minutes) async {
    final key = 'bubble$minutes';
    final cached = _cache[key];
    if (cached != null) return cached;
    final info = await vg.loadPicture(
      SvgAssetLoader(AppImage.path('service_truck')),
      null,
    );
    final text = TextPainter(
      text: TextSpan(
        text: '$minutes min',
        style: AppTypography.of(13, FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return _render(key, 76, 46, (c) {
      final rect = ui.RRect.fromRectAndRadius(
        const ui.Rect.fromLTWH(0.5, 0.5, 75, 29),
        const ui.Radius.circular(14.5),
      );
      c.drawRRect(rect, ui.Paint()..color = AppColors.white);
      c.drawRRect(
        rect,
        ui.Paint()
          ..color = AppColors.bubbleStroke
          ..style = ui.PaintingStyle.stroke,
      );
      c
        ..save()
        ..translate(10, 5)
        ..scale(19.2 / info.size.width, 19.2 / info.size.height)
        ..drawPicture(info.picture)
        ..restore();
      text.paint(c, ui.Offset(50 - text.width / 2, (30 - text.height) / 2));
    });
  }

  /// Pin numerado de un punto de entrega: negro si está abierto, gris si no.
  static Future<BitmapDescriptor> numbered(int n, {required bool open}) {
    return _render('num$n$open', 28, 38, (c) {
      c.translate(14, 28);
      c.drawPath(
        _pin(13, 9, 19),
        ui.Paint()..color = open ? AppColors.dark : AppColors.closedGrey,
      );
      final text = TextPainter(
        text: TextSpan(
          text: '$n',
          style: AppTypography.of(12, FontWeight.w700, color: AppColors.white),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(c, ui.Offset(-text.width / 2, -13 - text.height / 2));
    });
  }

  /// Tu ubicación: punto naranja con borde blanco y halo.
  static Future<BitmapDescriptor> me() {
    return _render('me', 36, 36, (c) {
      const center = ui.Offset(18, 18);
      c.drawCircle(
        center,
        16,
        ui.Paint()..color = AppColors.primary.withValues(alpha: 0.2),
      );
      c.drawCircle(center, 8, ui.Paint()..color = AppColors.white);
      c.drawCircle(center, 6, ui.Paint()..color = AppColors.primary);
    });
  }

  /// Gota con radio `r` y punta `tail` px por debajo del centro del arco.
  static ui.Path _pin(double r, double c1, double tail) {
    return ui.Path()
      ..moveTo(0, -2 * r)
      ..arcToPoint(ui.Offset(r, -r), radius: ui.Radius.circular(r))
      ..cubicTo(r, -r + c1, 0, -r + tail, 0, -r + tail)
      ..cubicTo(0, -r + tail, -r, -r + c1, -r, -r)
      ..arcToPoint(ui.Offset(0, -2 * r), radius: ui.Radius.circular(r))
      ..close();
  }
}
