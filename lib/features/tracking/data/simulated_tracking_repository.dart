import '../../../core/theme/app_durations.dart';
import '../domain/tracking.dart';

/// Simula el viaje: emite cada 100 ms durante 11 s y, 700 ms después,
/// marca el paquete como entregado.
class SimulatedTrackingRepository implements TrackingRepository {
  @override
  Stream<TrackingSnapshot> watch(
    String parcelId, {
    bool instant = false,
  }) async* {
    if (instant) {
      yield TrackingSnapshot.delivered();
      return;
    }
    yield TrackingSnapshot.at(0);
    await Future<void>.delayed(AppDurations.trackingWait);
    final total = AppDurations.trackingRun.inMilliseconds;
    final step = AppDurations.trackingTick.inMilliseconds;
    for (var ms = step; ms <= total; ms += step) {
      await Future<void>.delayed(AppDurations.trackingTick);
      yield TrackingSnapshot.at(ms / total);
    }
    await Future<void>.delayed(AppDurations.trackingDeliver);
    yield TrackingSnapshot.delivered();
  }
}
