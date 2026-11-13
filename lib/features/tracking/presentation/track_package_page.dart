import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/config/maps_config.dart';
import '../../../core/extensions/context_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/booking_card.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/courier_header.dart';
import '../../../core/widgets/delivery_status_banner.dart';
import '../../../core/widgets/shipment_stepper.dart' show StepLabel;
import '../domain/tracking.dart';
import 'google_track_map.dart';
import 'track_map.dart';
import 'track_sheet_extras.dart';
import 'tracking_bloc.dart';

/// Cómo se pinta cada fase (texto, banner, chip y nodo del stepper).
class TrackingView {
  const TrackingView({
    required this.variant,
    required this.text,
    required this.data,
    required this.chip,
    required this.current,
    required this.away,
  });

  factory TrackingView.of(TrackingSnapshot s) {
    final km = s.km.toStringAsFixed(1);
    switch (s.phase) {
      case TrackingPhase.packed:
        return TrackingView(
          variant: BannerVariant.packed,
          text: 'Empacado · llega en ${s.minutes} min',
          data: 'faltan $km km',
          chip: 'Proceso',
          current: 1,
          away: 'A ${s.minutes} min',
        );
      case TrackingPhase.transit:
        return TrackingView(
          variant: BannerVariant.transit,
          text: 'En camino · llega en ${s.minutes} min',
          data: 'faltan $km km',
          chip: 'Tránsito',
          current: 2,
          away: 'A ${s.minutes} min',
        );
      case TrackingPhase.delivered:
        return const TrackingView(
          variant: BannerVariant.delivered,
          text: 'Entregado a Amelia',
          data: 'Firmado',
          chip: 'Entregado',
          current: 4,
          away: null,
        );
    }
  }

  final BannerVariant variant;
  final String text;
  final String data;
  final String chip;
  final int current;
  final String? away;
}

class TrackPackagePage extends StatefulWidget {
  const TrackPackagePage({super.key, required this.parcelId});

  final String parcelId;

  @override
  State<TrackPackagePage> createState() => _TrackPackagePageState();
}

class _TrackPackagePageState extends State<TrackPackagePage> {
  /// Solo mínimo e intermedio: el máximo taparía el mapa y los botones.
  /// Pasado el intermedio, el contenido de la hoja se desplaza.
  static const double _minSize = 0.26;
  static const double _maxSize = 0.56;

  bool _started = false;

  /// Fracción de la pantalla que ocupa la hoja (0–1).
  final ValueNotifier<double> _extent = ValueNotifier<double>(_maxSize);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    context.read<TrackingBloc>().add(
      TrackingStarted(widget.parcelId, reduceMotion: context.reduceMotion),
    );
  }

  @override
  void dispose() {
    _extent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.mapBeige,
      child: LayoutBuilder(
        builder: (context, box) {
          final height = box.maxHeight;
          return Stack(
            children: [
              Positioned.fill(
                child: _MapLayer(extent: _extent, height: height),
              ),
              const Positioned(top: 62, left: 0, right: 0, child: _Header()),
              Positioned.fill(
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: (n) {
                    _extent.value = n.extent;
                    return false;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: _maxSize,
                    minChildSize: _minSize,
                    maxChildSize: _maxSize,
                    snap: true,
                    snapSizes: const [_minSize, _maxSize],
                    builder:
                        (context, controller) => _Sheet(controller: controller),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// El mapa de Google ocupa toda la pantalla y se encuadra en el área que
/// deja libre la hoja; el dibujado del prototipo es fijo.
class _MapLayer extends StatelessWidget {
  const _MapLayer({required this.extent, required this.height});

  final ValueNotifier<double> extent;
  final double height;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingBloc, TrackingState>(
      builder: (context, state) {
        final snapshot = state.snapshot ?? TrackingSnapshot.at(0);
        if (!MapsConfig.enabled) {
          return Align(
            alignment: Alignment.topCenter,
            child: _MapView(snapshot: snapshot),
          );
        }
        return ValueListenableBuilder<double>(
          valueListenable: extent,
          builder:
              (context, value, _) => _MapView(
                snapshot: snapshot,
                bottomInset: (value * height).clamp(0, height * 0.8),
              ),
        );
      },
    );
  }
}

/// Google Maps si hay clave; si no, el mapa dibujado del prototipo.
class _MapView extends StatelessWidget {
  const _MapView({required this.snapshot, this.bottomInset = 100});

  final TrackingSnapshot snapshot;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    if (MapsConfig.enabled) {
      return GoogleTrackMap(
        progress: snapshot.progress,
        minutes: snapshot.minutes,
        courierVisible: snapshot.courierVisible,
        bottomInset: bottomInset,
      );
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: snapshot.progress),
      duration: const Duration(milliseconds: 100),
      builder:
          (context, p, _) => TrackMap(
            progress: p,
            minutes: snapshot.minutes,
            courierVisible: snapshot.courierVisible,
          ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleIconButton(
            icon: 'arrow-l',
            label: 'Atrás',
            size: 50,
            shadow: true,
            iconSize: 21,
            onPressed: () => context.go(Routes.orders),
          ),
          const Text('Seguimiento', style: AppTypography.screenTitle),
          const CircleIconButton(
            icon: 'dots',
            label: 'Más opciones',
            size: 50,
            shadow: true,
            iconSize: 21,
          ),
        ],
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: AppShadows.sheetTop,
      ),
      child: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          final snapshot = state.snapshot ?? TrackingSnapshot.at(0);
          final view = TrackingView.of(snapshot);
          return SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
            child: Column(
              children: [
                const _Grabber(),
                const CourierHeader(
                  role: 'Reparto',
                  rating: '4.8',
                  name: 'Dana Reid',
                  callLabel: 'Llamar al repartidor',
                  chatLabel: 'Chatear con el repartidor',
                ),
                const SizedBox(height: 16),
                DeliveryStatusBanner(
                  variant: view.variant,
                  text: view.text,
                  data: view.data,
                ),
                const SizedBox(height: 14),
                BookingCard(
                  title: 'Reserva',
                  chip: view.chip,
                  number: 'M87952264',
                  current: view.current,
                  awayLabel: view.away,
                  stepLabels: _stepLabels(snapshot.phase, view.current),
                  cells: const [
                    ('Origen', 'Larcomar, Miraflores'),
                    ('Destino', 'San Isidro, Lima'),
                    ('Costo del pedido', '\$164.00'),
                    ('Cliente', 'Amelia'),
                  ],
                ),
                const SheetTitle('Tu repartidor'),
                const CourierExtras(),
                const SheetTitle('Detalles del paquete'),
                const PackageDetails(),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Pasos del envío con su hora (reemplaza al historial aparte).
List<StepLabel> _stepLabels(TrackingPhase phase, int current) {
  const steps = [
    ('Confirmado', '09:30'),
    ('Empacado', '09:41'),
    ('En camino', '09:58'),
    ('Entregado', '10:14'),
  ];
  return [
    for (var i = 0; i < steps.length; i++)
      StepLabel(
        steps[i].$1,
        i < current ? steps[i].$2 : (i == current ? 'Ahora' : null),
      ),
  ];
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomSheetTheme;
    final size = theme.dragHandleSize ?? const Size(32, 4);
    return Semantics(
      label: 'Arrastra para subir o bajar la hoja',
      child: Container(
        width: size.width,
        height: size.height,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: theme.dragHandleColor ?? AppColors.grabber,
          borderRadius: BorderRadius.circular(size.height / 2),
        ),
      ),
    );
  }
}
