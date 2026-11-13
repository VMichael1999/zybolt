import '../domain/shipments.dart';

class FakeShipmentsRepository implements ShipmentsRepository {
  @override
  Future<List<Parcel>> fetchParcels() async {
    return [
      Parcel(
        id: 'D314315783',
        name: 'Audífonos Studio',
        image: 'product_headphones',
        status: ParcelStatus.transit,
        step: 2,
        away: 'A 4 h',
        from: 'Sr. Quispe',
        sentOn: DateTime(2025, 10, 18),
        to: 'Miraflores, Lima',
        toDatePrefix: 'Estimado',
        toDate: DateTime(2026, 10, 19),
      ),
      Parcel(
        id: 'D514315784',
        name: 'Apple Watch Ultra',
        image: 'product_watch',
        status: ParcelStatus.process,
        step: 1,
        away: 'A 2 d',
        from: 'Sr. Quispe',
        sentOn: DateTime(2025, 10, 18),
        to: 'Miraflores, Lima',
        toDatePrefix: 'Estimado',
        toDate: DateTime(2026, 10, 19),
      ),
      Parcel(
        id: 'D314315785',
        name: 'MacBook Pro 14',
        image: 'product_laptop',
        status: ParcelStatus.delivered,
        step: 4,
        away: '',
        from: 'Sr. Quispe',
        sentOn: DateTime(2025, 10, 11),
        to: 'Miraflores, Lima',
        toDatePrefix: 'Entregado',
        toDate: DateTime(2025, 10, 16),
      ),
      Parcel(
        id: 'D714315786',
        name: 'Galaxy S24 Ultra',
        image: 'product_phone',
        status: ParcelStatus.transit,
        step: 2,
        away: 'A 9 h',
        from: 'Sra. Paredes',
        sentOn: DateTime(2025, 10, 19),
        to: 'San Isidro, Lima',
        toDatePrefix: 'Estimado',
        toDate: DateTime(2026, 10, 22),
      ),
      Parcel(
        id: 'D914315787',
        name: 'Beats Studio Pro',
        image: 'product_headphones',
        status: ParcelStatus.process,
        step: 0,
        away: 'A 3 d',
        from: 'Sr. Vargas',
        sentOn: DateTime(2025, 10, 20),
        to: 'Cusco, Perú',
        toDatePrefix: 'Estimado',
        toDate: DateTime(2026, 10, 24),
      ),
    ];
  }
}
