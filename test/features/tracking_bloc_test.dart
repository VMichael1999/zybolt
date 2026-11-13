import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zybolt/features/tracking/domain/tracking.dart';
import 'package:zybolt/features/tracking/presentation/tracking_bloc.dart';

/// Repositorio que emite pasos fijos.
class _FixedRepository implements TrackingRepository {
  @override
  Stream<TrackingSnapshot> watch(String parcelId, {bool instant = false}) {
    return Stream.fromIterable([
      TrackingSnapshot.at(0),
      TrackingSnapshot.at(0.5),
      TrackingSnapshot.at(1),
      TrackingSnapshot.delivered(),
    ]);
  }
}

void main() {
  test('las fases salen del progreso', () {
    expect(TrackingSnapshot.at(0).phase, TrackingPhase.packed);
    expect(TrackingSnapshot.at(0.34).phase, TrackingPhase.packed);
    expect(TrackingSnapshot.at(0.35).phase, TrackingPhase.transit);
    expect(TrackingSnapshot.at(1).phase, TrackingPhase.transit);
    expect(TrackingSnapshot.at(0).minutes, 8);
    expect(TrackingSnapshot.at(1).minutes, 1);
    expect(TrackingSnapshot.at(0).km, closeTo(6.8, 0.001));
    expect(TrackingSnapshot.at(0.99).km, 0);
  });

  blocTest<TrackingBloc, TrackingState>(
    'secuencia packed → transit → delivered',
    build: () => TrackingBloc(WatchTrackingUseCase(_FixedRepository())),
    act: (b) => b.add(const TrackingStarted('D314315783')),
    expect:
        () => [
          isA<TrackingState>().having(
            (s) => s.snapshot!.phase,
            'phase',
            TrackingPhase.packed,
          ),
          isA<TrackingState>().having(
            (s) => s.snapshot!.phase,
            'phase',
            TrackingPhase.transit,
          ),
          isA<TrackingState>().having(
            (s) => s.snapshot!.courierVisible,
            'courierVisible',
            false,
          ),
          isA<TrackingState>().having(
            (s) => s.snapshot!.phase,
            'phase',
            TrackingPhase.delivered,
          ),
        ],
  );
}
