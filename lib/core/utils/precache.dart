import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/app_image.dart';

const List<String> _preloaded = [
  'logo_mark',
  'loading_truck',
  'searching_map',
  'avatar_user',
  'service_ride',
  'service_transit',
  'service_car',
  'service_truck',
  'service_send',
  'parcel_boxes',
  'flag_de',
  'flag_fr',
  'flag_it',
  'flag_ch',
  'flag_nl',
  'map_nearby',
  'splash_scooter',
  'splash_map',
];

/// Carga las ilustraciones del login y del Home antes de `runApp`
/// para que no parpadeen.
Future<void> precacheIllustrations() async {
  await Future.wait([
    for (final name in _preloaded)
      () {
        final loader = SvgAssetLoader(AppImage.path(name));
        return svg.cache.putIfAbsent(
          loader.cacheKey(null),
          () => loader.loadBytes(null),
        );
      }(),
  ]);
}
