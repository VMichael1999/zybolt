import 'package:equatable/equatable.dart';

enum ParcelStatus { transit, process, delivered }

class Parcel extends Equatable {
  const Parcel({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.step,
    required this.away,
    required this.from,
    required this.sentOn,
    required this.to,
    required this.toDatePrefix,
    required this.toDate,
  });

  final String id;
  final String name;
  final String image;
  final ParcelStatus status;

  /// Índice del nodo actual (0–3); 4 = todo entregado.
  final int step;
  final String away;
  final String from;
  final DateTime sentOn;
  final String to;
  final String toDatePrefix;
  final DateTime toDate;

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    status,
    step,
    away,
    from,
    sentOn,
    to,
    toDatePrefix,
    toDate,
  ];
}

abstract class ShipmentsRepository {
  Future<List<Parcel>> fetchParcels();
}

class GetParcelsUseCase {
  const GetParcelsUseCase(this._repository);

  final ShipmentsRepository _repository;

  Future<List<Parcel>> call() => _repository.fetchParcels();
}
