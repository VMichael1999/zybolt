import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/config/maps_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/active_shipment_card.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/drop_off.dart';
import '../../../core/widgets/horizontal_cards.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/service_tile.dart';
import '../../../core/widgets/stat_cards.dart';
import '../../../core/widgets/update_timeline_tile.dart';
import '../domain/home.dart';
import 'google_nearby_map.dart';

/// Composite: la página recorre una lista de secciones.
abstract class HomeSection {
  const HomeSection();

  Widget build(BuildContext context, HomeSummary summary);
}

const List<HomeSection> kHomeSections = [
  ServicesSection(),
  ActiveShipmentsSection(),
  WeeklySection(),
  UpdatesSection(),
  DropOffSection(),
];

class ServicesSection extends HomeSection {
  const ServicesSection();

  @override
  Widget build(BuildContext context, HomeSummary summary) {
    const items = [
      ('service_ride', 'Viaje', 50.0),
      ('service_transit', 'Bus', 52.0),
      ('service_car', 'Auto', 50.0),
      ('service_truck', 'Camión', 52.0),
      ('service_send', 'Enviar', 50.0),
    ];
    return Column(
      children: [
        const SectionHeader(title: 'Servicios'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: Center(
                    child: ServiceTile(
                      image: items[i].$1,
                      label: items[i].$2,
                      imageSize: items[i].$3,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ActiveShipmentsSection extends HomeSection {
  const ActiveShipmentsSection();

  @override
  Widget build(BuildContext context, HomeSummary summary) {
    return Column(
      children: [
        SectionHeader(
          title: 'Envíos activos',
          action: 'Ver todo',
          onAction: () => context.go(Routes.orders),
        ),
        HorizontalCards(
          children: [
            for (final s in summary.shipments)
              ActiveShipmentCard(
                flagA: s.flagA,
                flagB: s.flagB,
                statusLabel: s.statusLabel,
                delivered: s.delivered,
                from: s.from,
                to: s.to,
                order: s.order,
              ),
          ],
        ),
      ],
    );
  }
}

class WeeklySection extends HomeSection {
  const WeeklySection();

  @override
  Widget build(BuildContext context, HomeSummary summary) {
    final stats = summary.stats;
    return Column(
      children: [
        const SectionHeader(title: 'Esta semana'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 125,
                  child: WeeklyStatCard(
                    title: 'Paquetes enviados',
                    range: stats.range,
                    total: '${stats.parcelsSent}',
                    delta: stats.growth,
                    bars: [
                      for (final d in stats.days)
                        WeeklyBar(
                          label: d.label,
                          height: d.height,
                          highlight: d.highlight,
                          value: d.value,
                          muted: d.height < 10,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 100,
                  child: Column(
                    children: [
                      StatCard(
                        leading: const BoltBadge(),
                        value: '${stats.onTimePercent}%',
                        label: 'A tiempo',
                        detail: stats.avgDays,
                      ),
                      const SizedBox(height: 12),
                      StatCard(
                        leading: const IconSquare(
                          icon: 'wallet',
                          color: AppColors.progressDot,
                        ),
                        value: Fmt.money(stats.spent),
                        label: 'Gastado',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class UpdatesSection extends HomeSection {
  const UpdatesSection();

  static UpdateKind _kind(UpdateType t) => switch (t) {
    UpdateType.live => UpdateKind.live,
    UpdateType.normal => UpdateKind.normal,
    UpdateType.success => UpdateKind.success,
  };

  @override
  Widget build(BuildContext context, HomeSummary summary) {
    final items = summary.updates;
    return Column(
      children: [
        const SectionHeader(title: 'Novedades', action: 'Ver todo'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                UpdateTimelineTile(
                  time: items[i].time,
                  title: items[i].title,
                  detail: items[i].detail,
                  icon: items[i].icon,
                  kind: _kind(items[i].type),
                  active: i == 0,
                  timeMuted: i != 0,
                  isLast: i == items.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class DropOffSection extends HomeSection {
  const DropOffSection();

  @override
  Widget build(BuildContext context, HomeSummary summary) {
    return Column(
      children: [
        const SectionHeader(
          title: 'Puntos de entrega cercanos',
          action: 'Mapa',
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              NearbyMap(
                openLabel: '${summary.openDropOffs} abiertos cerca de ti',
                map:
                    MapsConfig.enabled
                        ? GoogleNearbyMap(points: summary.dropOffs)
                        : null,
              ),
              for (final d in summary.dropOffs)
                DropOffTile(
                  number: d.number,
                  name: d.name,
                  detail: d.detail,
                  status: d.status,
                  distance: Fmt.km(d.distanceKm),
                  open: d.open,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Ícono suelto reutilizado por las secciones.
class SectionIcon extends StatelessWidget {
  const SectionIcon(this.name, {super.key});

  final String name;

  @override
  Widget build(BuildContext context) => AppIcon(name);
}
