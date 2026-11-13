import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/theme/app_colors.dart';
import 'map_markers.dart';
import 'map_style.dart';
import 'route_geometry.dart';

/// Mapa de Google con la ruta, los pines de tienda y cliente, el repartidor
/// y su burbuja de tiempo.
class GoogleTrackMap extends StatefulWidget {
  const GoogleTrackMap({
    super.key,
    required this.progress,
    required this.minutes,
    required this.courierVisible,
    this.bottomInset = 100,
  });

  /// Espacio que tapa la hoja inferior; el mapa se encuadra en lo que queda.
  final double bottomInset;

  final double progress;
  final int minutes;
  final bool courierVisible;

  @override
  State<GoogleTrackMap> createState() => _GoogleTrackMapState();
}

class _GoogleTrackMapState extends State<GoogleTrackMap> {
  BitmapDescriptor? _store;
  BitmapDescriptor? _customer;
  BitmapDescriptor? _courier;
  BitmapDescriptor? _bubble;
  GoogleMapController? _controller;
  double _fittedInset = -1;

  @override
  void initState() {
    super.initState();
    _loadIcons();
    _loadBubble(widget.minutes);
  }

  @override
  void didUpdateWidget(GoogleTrackMap old) {
    super.didUpdateWidget(old);
    if (old.minutes != widget.minutes) _loadBubble(widget.minutes);
    if ((widget.bottomInset - _fittedInset).abs() >= 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fit());
    }
  }

  /// Vuelve a encuadrar toda la ruta en el área visible del mapa.
  void _fit() {
    _fittedInset = widget.bottomInset;
    _controller?.moveCamera(
      CameraUpdate.newLatLngBounds(RouteGeometry.bounds, 40),
    );
  }

  Future<void> _loadIcons() async {
    final icons = await Future.wait([
      MapMarkers.store(),
      MapMarkers.customer(),
      MapMarkers.courier(),
    ]);
    if (!mounted) return;
    setState(() {
      _store = icons[0];
      _customer = icons[1];
      _courier = icons[2];
    });
  }

  Future<void> _loadBubble(int minutes) async {
    final icon = await MapMarkers.bubble(minutes);
    if (!mounted) return;
    setState(() {
      _bubble = icon;
    });
  }

  Set<Polyline> _polylines(double f) {
    Polyline line(String id, List<LatLng> pts, Color color, int z) => Polyline(
      polylineId: PolylineId(id),
      points: pts,
      color: color,
      width: 5,
      zIndex: z,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
    );
    return {
      line('route', RouteGeometry.full, AppColors.routeGrey, 1),
      line('done', RouteGeometry.upTo(f), AppColors.primary, 2),
    };
  }

  Set<Marker> _markers(double f) {
    final courierAt = RouteGeometry.pointAt(f);
    return {
      if (_store != null)
        Marker(
          markerId: const MarkerId('store'),
          position: RouteGeometry.full.first,
          icon: _store!,
          anchor: const Offset(0.5, 0.957),
          zIndexInt: 3,
        ),
      if (_customer != null)
        Marker(
          markerId: const MarkerId('customer'),
          position: RouteGeometry.full.last,
          icon: _customer!,
          anchor: const Offset(0.5, 1),
          zIndexInt: 3,
        ),
      if (_courier != null)
        Marker(
          markerId: const MarkerId('courier'),
          position: courierAt,
          icon: _courier!,
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 4,
        ),
      if (_bubble != null && widget.courierVisible)
        Marker(
          markerId: const MarkerId('eta'),
          position: courierAt,
          icon: _bubble!,
          anchor: const Offset(0.5, 1),
          zIndexInt: 5,
          consumeTapEvents: true,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final f = RouteGeometry.fraction(widget.progress);
    final b = RouteGeometry.bounds;
    final center = LatLng(
      (b.southwest.latitude + b.northeast.latitude) / 2,
      (b.southwest.longitude + b.northeast.longitude) / 2,
    );
    return SizedBox.expand(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: center, zoom: 14.2),
        style: kTrackMapStyle,
        // Deja libre el logo de Google por encima de la hoja inferior.
        padding: EdgeInsets.only(top: 110, bottom: widget.bottomInset),
        polylines: _polylines(f),
        markers: _markers(f),
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        buildingsEnabled: false,
        trafficEnabled: false,
        onMapCreated: (c) {
          _controller = c;
          _fit();
        },
      ),
    );
  }
}
