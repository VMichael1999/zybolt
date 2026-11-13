import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_durations.dart';
import '../../auth/domain/auth.dart';

class SplashState extends Equatable {
  const SplashState({this.finished = false, this.hasSession = false});

  final bool finished;
  final bool hasSession;

  @override
  List<Object?> get props => [finished, hasSession];
}

/// Espera a que termine la animación y avisa para navegar.
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._auth) : super(const SplashState());

  final AuthRepository _auth;

  Future<void> start({required bool reduceMotion}) async {
    final wait =
        reduceMotion
            ? AppDurations.splashReduced
            : AppDurations.splash + AppDurations.splashHold;
    await Future<void>.delayed(wait);
    final session = await _auth.savedSession();
    if (isClosed) return;
    emit(SplashState(finished: true, hasSession: session != null));
  }
}
