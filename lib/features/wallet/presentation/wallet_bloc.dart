import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/wallet.dart';

enum WalletStatus { initial, loading, success, failure }

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class WalletStarted extends WalletEvent {
  const WalletStarted();
}

class BalanceVisibilityToggled extends WalletEvent {
  const BalanceVisibilityToggled();
}

class WalletState extends Equatable {
  const WalletState({
    this.status = WalletStatus.initial,
    this.summary,
    this.balanceHidden = false,
  });

  final WalletStatus status;
  final WalletSummary? summary;
  final bool balanceHidden;

  WalletState copyWith({
    WalletStatus? status,
    WalletSummary? summary,
    bool? balanceHidden,
  }) {
    return WalletState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      balanceHidden: balanceHidden ?? this.balanceHidden,
    );
  }

  @override
  List<Object?> get props => [status, summary, balanceHidden];
}

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc(this._repository) : super(const WalletState()) {
    on<WalletStarted>(_onStarted);
    on<BalanceVisibilityToggled>(
      (_, emit) => emit(state.copyWith(balanceHidden: !state.balanceHidden)),
    );
  }

  final WalletRepository _repository;

  Future<void> _onStarted(WalletStarted e, Emitter<WalletState> emit) async {
    emit(state.copyWith(status: WalletStatus.loading));
    try {
      final summary = await _repository.loadSummary();
      emit(state.copyWith(status: WalletStatus.success, summary: summary));
    } catch (_) {
      emit(state.copyWith(status: WalletStatus.failure));
    }
  }
}
