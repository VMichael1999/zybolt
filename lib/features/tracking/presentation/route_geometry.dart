import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'route_data.dart';
import 'track_map.dart' show kRouteStart;

/// Cálculos sobre la ruta real de reparto ([kDeliveryRoute]).
abstract final class RouteGeometry {
  static const double _metersPerDegLat = 111320;

  static double _meters(LatLng a, LatLng b) {
    final dLat = (b.latitude - a.latitude) * _metersPerDegLat;
    final dLng =
        (b.longitude - a.longitude) *
        _metersPerDegLat *
        math.cos(a.latitude * math.pi / 180);
    return math.sqrt(dLat * dLat + dLng * dLng);
  }

  static final List<double> _cumulative = _buildCumulative();

  static List<double> _buildCumulative() {
    final out = <double>[0];
    for (var i = 1; i < kDeliveryRoute.length; i++) {
      out.add(out.last + _meters(kDeliveryRoute[i - 1], kDeliveryRoute[i]));
    }
    return out;
  }

  static double get totalMeters => _cumulative.last;

  /// Punto de la ruta a la fracción `f` (0–1) de su longitud.
  static LatLng pointAt(double f) {
    final target = totalMeters * f.clamp(0.0, 1.0);
    for (var i = 1; i < kDeliveryRoute.length; i++) {
      if (target <= _cumulative[i]) {
        final seg = _cumulative[i] - _cumulative[i - 1];
        final t = seg == 0 ? 0.0 : (target - _cumulative[i - 1]) / seg;
        final a = kDeliveryRoute[i - 1];
        final b = kDeliveryRoute[i];
        return LatLng(
          a.latitude + (b.latitude - a.latitude) * t,
          a.longitude + (b.longitude - a.longitude) * t,
        );
      }
    }
    return kDeliveryRoute.last;
  }

  /// Ruta completa.
  static List<LatLng> get full => kDeliveryRoute;

  /// Tramo recorrido hasta la fracción `f` de la ruta.
  static List<LatLng> upTo(double f) {
    final target = totalMeters * f.clamp(0.0, 1.0);
    final out = <LatLng>[kDeliveryRoute.first];
    for (var i = 1; i < kDeliveryRoute.length; i++) {
      if (_cumulative[i] < target) {
        out.add(kDeliveryRoute[i]);
      } else {
        break;
      }
    }
    out.add(pointAt(f));
    return out;
  }

  /// Fracción de la ruta para un progreso `p` del viaje (parte del 42 %).
  static double fraction(double progress) =>
      kRouteStart + (1 - kRouteStart) * progress;

  static LatLngBounds get bounds => boundsOf(kDeliveryRoute);

  static LatLngBounds boundsOf(List<LatLng> points) {
    final lats = points.map((p) => p.latitude);
    final lngs = points.map((p) => p.longitude);
    return LatLngBounds(
      southwest: LatLng(lats.reduce(math.min), lngs.reduce(math.min)),
      northeast: LatLng(lats.reduce(math.max), lngs.reduce(math.max)),
    );
  }
}
