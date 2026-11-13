import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../tracking/presentation/map_markers.dart';
import '../../tracking/presentation/route_geometry.dart';
import '../domain/home.dart';
import 'nearby_map_style.dart';

/// Mapa de Google de «Puntos cercanos»: pines numerados y tu ubicación.
class GoogleNearbyMap extends StatefulWidget {
  const GoogleNearbyMap({super.key, required this.points});

  final List<DropOffPoint> points;

  /// Tu ubicación (Av. Pardo, Miraflores).
  static const LatLng me = LatLng(-12.11700, -77.02300);

  @override
  State<GoogleNearbyMap> createState() => _GoogleNearbyMapState();
}

class _GoogleNearbyMapState extends State<GoogleNearbyMap> {
  final Map<String, BitmapDescriptor> _icons = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = <String, BitmapDescriptor>{'me': await MapMarkers.me()};
    for (final p in widget.points) {
      entries['p${p.number}'] = await MapMarkers.numbered(
        p.number,
        open: p.open,
      );
    }
    if (!mounted) return;
    setState(() => _icons.addAll(entries));
  }

  LatLngBounds get _bounds => RouteGeometry.boundsOf([
    GoogleNearbyMap.me,
    for (final p in widget.points) LatLng(p.lat, p.lng),
  ]);

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{
      if (_icons['me'] != null)
        Marker(
          markerId: const MarkerId('me'),
          position: GoogleNearbyMap.me,
          icon: _icons['me']!,
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 2,
        ),
      for (final p in widget.points)
        if (_icons['p${p.number}'] != null)
          Marker(
            markerId: MarkerId('p${p.number}'),
            position: LatLng(p.lat, p.lng),
            icon: _icons['p${p.number}']!,
            anchor: const Offset(0.5, 1),
            zIndexInt: 1,
          ),
    };
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: GoogleNearbyMap.me,
        zoom: 13.6,
      ),
      style: kNearbyMapStyle,
      markers: markers,
      // Deja libre el logo de Google bajo el chip y los pines.
      padding: const EdgeInsets.only(top: 44, bottom: 4),
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      buildingsEnabled: false,
      onMapCreated:
          (c) => c.moveCamera(CameraUpdate.newLatLngBounds(_bounds, 28)),
    );
  }
}
