import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zybolt/core/theme/app_durations.dart';
import 'package:zybolt/features/shipments/data/fake_shipments_repository.dart';
import 'package:zybolt/features/shipments/domain/shipments.dart';
import 'package:zybolt/features/shipments/presentation/shipments_bloc.dart';

void main() {
  ShipmentsBloc build() =>
      ShipmentsBloc(GetParcelsUseCase(FakeShipmentsRepository()));

  Future<List<Parcel>> parcels() => FakeShipmentsRepository().fetchParcels();

  test('los contadores se calculan a partir de la lista', () async {
    final state = ShipmentsState(all: await parcels());
    expect(state.countFor(ShipmentsFilter.all), 5);
    expect(state.countFor(ShipmentsFilter.transit), 2);
    expect(state.countFor(ShipmentsFilter.process), 2);
    expect(state.countFor(ShipmentsFilter.delivered), 1);
  });

  blocTest<ShipmentsBloc, ShipmentsState>(
    'carga los envíos',
    build: build,
    act: (b) => b.add(const ShipmentsStarted()),
    expect:
        () => [
          const ShipmentsState(status: ShipmentsStatus.loading),
          isA<ShipmentsState>()
              .having((s) => s.status, 'status', ShipmentsStatus.success)
              .having((s) => s.all.length, 'all', 5),
        ],
  );

  blocTest<ShipmentsBloc, ShipmentsState>(
    'el filtro deja solo los envíos del estado elegido',
    build: build,
    act: (b) async {
      b.add(const ShipmentsStarted());
      await Future<void>.delayed(Duration.zero);
      b.add(const ShipmentsFilterChanged(ShipmentsFilter.delivered));
    },
    skip: 2,
    verify: (b) {
      expect(b.state.filter, ShipmentsFilter.delivered);
      expect(b.state.visible.map((p) => p.name), ['MacBook Pro 14']);
    },
  );

  blocTest<ShipmentsBloc, ShipmentsState>(
    'la búsqueda espera 250 ms y solo aplica la última consulta',
    build: build,
    act: (b) async {
      b.add(const ShipmentsStarted());
      await Future<void>.delayed(Duration.zero);
      b
        ..add(const ShipmentsQueryChanged('m'))
        ..add(const ShipmentsQueryChanged('mac'));
    },
    skip: 2,
    wait: AppDurations.debounce + const Duration(milliseconds: 50),
    expect:
        () => [isA<ShipmentsState>().having((s) => s.query, 'query', 'mac')],
    verify: (b) => expect(b.state.visible.map((p) => p.id), ['D314315785']),
  );

  blocTest<ShipmentsBloc, ShipmentsState>(
    'busca también por nombre y ID',
    build: build,
    act: (b) async {
      b.add(const ShipmentsStarted());
      await Future<void>.delayed(Duration.zero);
      b.add(const ShipmentsQueryChanged('galaxy'));
    },
    skip: 2,
    wait: AppDurations.debounce + const Duration(milliseconds: 50),
    verify: (b) => expect(b.state.visible.single.id, 'D714315786'),
  );
}
