import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/tracking.dart';

enum TrackingStatus { initial, tracking, failure }

sealed class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class TrackingStarted extends TrackingEvent {
  const TrackingStarted(this.parcelId, {this.reduceMotion = false});

  final String parcelId;
  final bool reduceMotion;

  @override
  List<Object?> get props => [parcelId, reduceMotion];
}

class TrackingState extends Equatable {
  const TrackingState({this.status = TrackingStatus.initial, this.snapshot});

  final TrackingStatus status;
  final TrackingSnapshot? snapshot;

  TrackingState copyWith({TrackingStatus? status, TrackingSnapshot? snapshot}) {
    return TrackingState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
    );
  }

  @override
  List<Object?> get props => [status, snapshot];
}

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  TrackingBloc(this._watch) : super(const TrackingState()) {
    on<TrackingStarted>(_onStarted);
  }

  final WatchTrackingUseCase _watch;

  Future<void> _onStarted(TrackingStarted event, Emitter<TrackingState> emit) {
    return emit.forEach<TrackingSnapshot>(
      _watch(event.parcelId, instant: event.reduceMotion),
      onData:
          (s) => state.copyWith(status: TrackingStatus.tracking, snapshot: s),
      onError: (_, __) => state.copyWith(status: TrackingStatus.failure),
    );
  }
}
