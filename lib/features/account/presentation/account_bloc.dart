import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/domain/auth.dart';
import '../domain/account.dart';

enum AccountStatus { initial, loading, success, failure }

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class AccountStarted extends AccountEvent {
  const AccountStarted();
}

class PreferenceToggled extends AccountEvent {
  const PreferenceToggled(this.key);

  final PreferenceKey key;

  @override
  List<Object?> get props => [key];
}

class LogoutRequested extends AccountEvent {
  const LogoutRequested();
}

class AccountState extends Equatable {
  const AccountState({
    this.status = AccountStatus.initial,
    this.profile,
    this.membership,
    this.preferences = const Preferences(),
    this.loggedOut = false,
  });

  final AccountStatus status;
  final Profile? profile;
  final Membership? membership;
  final Preferences preferences;
  final bool loggedOut;

  AccountState copyWith({
    AccountStatus? status,
    Profile? profile,
    Membership? membership,
    Preferences? preferences,
    bool? loggedOut,
  }) {
    return AccountState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      membership: membership ?? this.membership,
      preferences: preferences ?? this.preferences,
      loggedOut: loggedOut ?? this.loggedOut,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    membership,
    preferences,
    loggedOut,
  ];
}

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc(this._account, this._auth) : super(const AccountState()) {
    on<AccountStarted>(_onStarted);
    on<PreferenceToggled>(_onToggled);
    on<LogoutRequested>(_onLogout);
  }

  final AccountRepository _account;
  final AuthRepository _auth;

  Future<void> _onStarted(
    AccountStarted event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));
    try {
      final profile = await _account.loadProfile();
      final membership = await _account.loadMembership();
      final prefs = await _account.loadPreferences();
      emit(
        state.copyWith(
          status: AccountStatus.success,
          profile: profile,
          membership: membership,
          preferences: prefs,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: AccountStatus.failure));
    }
  }

  /// Cambio optimista: se refleja al instante y se revierte si falla.
  Future<void> _onToggled(
    PreferenceToggled event,
    Emitter<AccountState> emit,
  ) async {
    final before = state.preferences;
    final next = !before.valueOf(event.key);
    emit(state.copyWith(preferences: before.withValue(event.key, next)));
    try {
      await _account.savePreference(event.key, next);
    } catch (_) {
      emit(state.copyWith(preferences: before));
    }
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AccountState> emit,
  ) async {
    await _auth.signOut();
    emit(state.copyWith(loggedOut: true));
  }
}
