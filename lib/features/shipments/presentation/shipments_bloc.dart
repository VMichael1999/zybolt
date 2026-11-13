import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../core/theme/app_durations.dart';
import '../domain/shipments.dart';

enum ShipmentsStatus { initial, loading, success, failure }

/// Filtro de la lista: todos o un estado concreto.
enum ShipmentsFilter { all, transit, process, delivered }

sealed class ShipmentsEvent extends Equatable {
  const ShipmentsEvent();

  @override
  List<Object?> get props => [];
}

class ShipmentsStarted extends ShipmentsEvent {
  const ShipmentsStarted();
}

class ShipmentsFilterChanged extends ShipmentsEvent {
  const ShipmentsFilterChanged(this.filter);

  final ShipmentsFilter filter;

  @override
  List<Object?> get props => [filter];
}

class ShipmentsQueryChanged extends ShipmentsEvent {
  const ShipmentsQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class ShipmentsState extends Equatable {
  const ShipmentsState({
    this.all = const [],
    this.filter = ShipmentsFilter.all,
    this.query = '',
    this.status = ShipmentsStatus.initial,
  });

  final List<Parcel> all;
  final ShipmentsFilter filter;
  final String query;
  final ShipmentsStatus status;

  /// Cantidad por filtro, calculada a partir de la lista.
  int countFor(ShipmentsFilter f) {
    switch (f) {
      case ShipmentsFilter.all:
        return all.length;
      case ShipmentsFilter.transit:
        return all.where((p) => p.status == ParcelStatus.transit).length;
      case ShipmentsFilter.process:
        return all.where((p) => p.status == ParcelStatus.process).length;
      case ShipmentsFilter.delivered:
        return all.where((p) => p.status == ParcelStatus.delivered).length;
    }
  }

  bool _matches(Parcel p) {
    final byStatus = switch (filter) {
      ShipmentsFilter.all => true,
      ShipmentsFilter.transit => p.status == ParcelStatus.transit,
      ShipmentsFilter.process => p.status == ParcelStatus.process,
      ShipmentsFilter.delivered => p.status == ParcelStatus.delivered,
    };
    if (!byStatus) return false;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return '${p.id} ${p.name}'.toLowerCase().contains(q);
  }

  List<Parcel> get visible => all.where(_matches).toList();

  ShipmentsState copyWith({
    List<Parcel>? all,
    ShipmentsFilter? filter,
    String? query,
    ShipmentsStatus? status,
  }) {
    return ShipmentsState(
      all: all ?? this.all,
      filter: filter ?? this.filter,
      query: query ?? this.query,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [all, filter, query, status];
}

EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (events, mapper) =>
      restartable<E>().call(events.debounce(duration), mapper);
}

class ShipmentsBloc extends Bloc<ShipmentsEvent, ShipmentsState> {
  ShipmentsBloc(this._getParcels) : super(const ShipmentsState()) {
    on<ShipmentsStarted>(_onStarted);
    on<ShipmentsFilterChanged>(
      (e, emit) => emit(state.copyWith(filter: e.filter)),
    );
    on<ShipmentsQueryChanged>(
      (e, emit) => emit(state.copyWith(query: e.query)),
      transformer: _debounceRestartable(AppDurations.debounce),
    );
  }

  final GetParcelsUseCase _getParcels;

  Future<void> _onStarted(
    ShipmentsStarted event,
    Emitter<ShipmentsState> emit,
  ) async {
    emit(state.copyWith(status: ShipmentsStatus.loading));
    try {
      final parcels = await _getParcels();
      emit(state.copyWith(all: parcels, status: ShipmentsStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ShipmentsStatus.failure));
    }
  }
}
