import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/auth.dart';

enum LoginStatus { initial, loading, success, failure }

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends LoginEvent {
  const EmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

class PasswordVisibilityToggled extends LoginEvent {
  const PasswordVisibilityToggled();
}

class KeepSignedInToggled extends LoginEvent {
  const KeepSignedInToggled();
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.obscure = true,
    this.keepSignedIn = true,
    this.status = LoginStatus.initial,
    this.error,
  });

  final String email;
  final String password;
  final bool obscure;
  final bool keepSignedIn;
  final LoginStatus status;
  final String? error;

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscure,
    bool? keepSignedIn,
    LoginStatus? status,
    String? error,
    bool clearError = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscure: obscure ?? this.obscure,
      keepSignedIn: keepSignedIn ?? this.keepSignedIn,
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    obscure,
    keepSignedIn,
    status,
    error,
  ];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._signIn) : super(const LoginState()) {
    on<EmailChanged>((e, emit) => emit(state.copyWith(email: e.email)));
    on<PasswordChanged>(
      (e, emit) => emit(state.copyWith(password: e.password)),
    );
    on<PasswordVisibilityToggled>(
      (_, emit) => emit(state.copyWith(obscure: !state.obscure)),
    );
    on<KeepSignedInToggled>(
      (_, emit) => emit(state.copyWith(keepSignedIn: !state.keepSignedIn)),
    );
    on<LoginSubmitted>(_onSubmitted);
  }

  final SignInUseCase _signIn;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status == LoginStatus.loading) return;
    emit(state.copyWith(status: LoginStatus.loading, clearError: true));
    try {
      await _signIn(
        email: state.email,
        password: state.password,
        keepSignedIn: state.keepSignedIn,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          error: 'No pudimos iniciar sesión. Inténtalo de nuevo.',
        ),
      );
    }
  }
}
