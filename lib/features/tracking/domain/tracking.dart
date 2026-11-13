import 'dart:math' as math;

import 'package:equatable/equatable.dart';

enum TrackingPhase { packed, transit, delivered }

class TrackingSnapshot extends Equatable {
  const TrackingSnapshot({
    required this.progress,
    required this.phase,
    required this.minutes,
    required this.km,
  });

  /// Progreso `p` de 0 a 1 (el repartidor parte del 42 % de la ruta).
  factory TrackingSnapshot.at(double p) {
    final clamped = p.clamp(0.0, 1.0);
    return TrackingSnapshot(
      progress: clamped,
      phase: clamped < 0.35 ? TrackingPhase.packed : TrackingPhase.transit,
      minutes: math.max(1, (8 * (1 - clamped)).round()),
      km: clamped > 0.97 && clamped >= 0.35 ? 0.0 : 6.8 * (1 - clamped),
    );
  }

  factory TrackingSnapshot.delivered() => const TrackingSnapshot(
    progress: 1,
    phase: TrackingPhase.delivered,
    minutes: 1,
    km: 0,
  );

  final double progress;
  final TrackingPhase phase;
  final int minutes;
  final double km;

  bool get courierVisible => progress < 1;

  @override
  List<Object?> get props => [progress, phase, minutes, km];
}

abstract class TrackingRepository {
  /// Emite instantáneas del seguimiento. Con `instant` salta al final.
  Stream<TrackingSnapshot> watch(String parcelId, {bool instant = false});
}

class WatchTrackingUseCase {
  const WatchTrackingUseCase(this._repository);

  final TrackingRepository _repository;

  Stream<TrackingSnapshot> call(String parcelId, {bool instant = false}) =>
      _repository.watch(parcelId, instant: instant);
}
