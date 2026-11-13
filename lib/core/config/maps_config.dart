import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Estado de la configuración de Google Maps.
///
/// Si no hay clave en el `.env` (o en pruebas), el seguimiento usa el mapa
/// dibujado del prototipo en vez del SDK de Google.
abstract final class MapsConfig {
  static const String envKey = 'EXPO_PUBLIC_GOOGLE_MAPS_API_KEY';

  static bool _enabled = false;

  static bool get enabled => _enabled;

  /// Carga el `.env` y activa Google Maps solo si trae la clave.
  static Future<void> init() async {
    try {
      await dotenv.load();
      _enabled = (dotenv.maybeGet(envKey) ?? '').trim().isNotEmpty;
    } catch (_) {
      _enabled = false;
    }
  }
}
