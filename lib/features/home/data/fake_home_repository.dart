import '../domain/home.dart';

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({this.delay = const Duration(milliseconds: 450)});

  final Duration delay;

  @override
  Future<HomeSummary> loadSummary() async {
    await Future<void>.delayed(delay);
    return HomeSummary(
      userName: 'Michael Dev',
      greeting: 'Buenas tardes,',
      current: CurrentDelivery(
        trackingNumber: 'AB–889641',
        status: 'En camino',
        sentOn: DateTime(2026, 10, 21),
        estimatedOn: DateTime(2026, 10, 26),
      ),
      shipments: const [
        ActiveShipment(
          flagA: 'flag_pe',
          flagB: 'flag_cl',
          from: 'Lima',
          to: 'Santiago',
          order: 'Orden PE-586340',
          delivered: false,
          statusLabel: 'En camino',
        ),
        ActiveShipment(
          flagA: 'flag_ar',
          flagB: 'flag_es',
          from: 'Buenos Aires',
          to: 'Madrid',
          order: 'Orden AR-229481',
          delivered: true,
          statusLabel: 'Entregado',
        ),
        ActiveShipment(
          flagA: 'flag_us',
          flagB: 'flag_jp',
          from: 'Nueva York',
          to: 'Tokio',
          order: 'Orden US-771205',
          delivered: false,
          statusLabel: 'En camino',
        ),
        ActiveShipment(
          flagA: 'flag_gb',
          flagB: 'flag_de',
          from: 'Londres',
          to: 'Berlín',
          order: 'Orden GB-448120',
          delivered: false,
          statusLabel: 'En camino',
        ),
      ],
      stats: const WeeklyStats(
        range: '19 – 25 oct',
        parcelsSent: 32,
        growth: '+18%',
        days: [
          WeekDay('L', 44),
          WeekDay('M', 66),
          WeekDay('X', 32),
          WeekDay('J', 76),
          WeekDay('V', 54),
          WeekDay('S', 86, highlight: true, value: '7'),
          WeekDay('D', 3),
        ],
        onTimePercent: 98,
        avgDays: '2.4 días en promedio',
        spent: 186.40,
      ),
      updates: const [
        TrackingUpdate(
          time: '10:24',
          title: 'En reparto',
          detail: 'AB-889641 · a 3 paradas',
          icon: 'truck',
          type: UpdateType.live,
        ),
        TrackingUpdate(
          time: '08:10',
          title: 'Llegó al centro de clasificación',
          detail: 'PE-586340 · Hub Aeropuerto de Santiago',
          icon: 'building',
          type: UpdateType.normal,
        ),
        TrackingUpdate(
          time: 'Ayer',
          title: 'Entregado',
          detail: 'AR-229481 · Firmado por Lucía',
          icon: 'circle-check',
          type: UpdateType.success,
        ),
      ],
      dropOffs: const [
        DropOffPoint(
          number: 1,
          name: 'Punto Larcomar',
          detail: 'Local 112, nivel 1',
          status: 'Abierto · Hasta las 22:00',
          distanceKm: 0.8,
          open: true,
          lat: -12.13190,
          lng: -77.02990,
        ),
        DropOffPoint(
          number: 2,
          name: 'Casillero Parque Kennedy',
          detail: 'Autoservicio, Av. Larco',
          status: 'Abierto · 24 horas',
          distanceKm: 1.4,
          open: true,
          lat: -12.12190,
          lng: -77.02970,
        ),
        DropOffPoint(
          number: 3,
          name: 'Hub Óvalo Gutiérrez',
          detail: 'Local 3, Av. Arequipa',
          status: 'Cerrado · Abre a las 08:00',
          distanceKm: 2.6,
          open: false,
          lat: -12.11230,
          lng: -77.03780,
        ),
      ],
    );
  }
}
