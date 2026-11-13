import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/home.dart';

enum HomeStatus { initial, loading, success, failure }

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeState extends Equatable {
  const HomeState({this.status = HomeStatus.initial, this.summary});

  final HomeStatus status;
  final HomeSummary? summary;

  HomeState copyWith({HomeStatus? status, HomeSummary? summary}) {
    return HomeState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [status, summary];
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
  }

  final HomeRepository _repository;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final summary = await _repository.loadSummary();
      emit(state.copyWith(status: HomeStatus.success, summary: summary));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
