import 'package:get_it/get_it.dart';

import '../features/account/data/fake_account_repository.dart';
import '../features/account/domain/account.dart';
import '../features/account/presentation/account_bloc.dart';
import '../features/auth/data/fake_auth_repository.dart';
import '../features/auth/domain/auth.dart';
import '../features/auth/presentation/login_bloc.dart';
import '../features/home/data/fake_home_repository.dart';
import '../features/home/domain/home.dart';
import '../features/home/presentation/home_bloc.dart';
import '../features/shipments/data/fake_shipments_repository.dart';
import '../features/shipments/domain/shipments.dart';
import '../features/shipments/presentation/shipments_bloc.dart';
import '../features/splash/presentation/splash_cubit.dart';
import '../features/tracking/data/simulated_tracking_repository.dart';
import '../features/tracking/domain/tracking.dart';
import '../features/tracking/presentation/tracking_bloc.dart';
import '../features/wallet/data/fake_wallet_repository.dart';
import '../features/wallet/domain/wallet.dart';
import '../features/wallet/presentation/wallet_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registra repositorios (singletons), casos de uso y BLoCs (factories).
Future<void> setupDi() async {
  await sl.reset();

  // Repositorios
  sl
    ..registerLazySingleton<AuthRepository>(FakeAuthRepository.new)
    ..registerLazySingleton<HomeRepository>(FakeHomeRepository.new)
    ..registerLazySingleton<ShipmentsRepository>(FakeShipmentsRepository.new)
    ..registerLazySingleton<TrackingRepository>(SimulatedTrackingRepository.new)
    ..registerLazySingleton<WalletRepository>(FakeWalletRepository.new)
    ..registerLazySingleton<AccountRepository>(FakeAccountRepository.new);

  // Casos de uso
  sl
    ..registerLazySingleton(() => SignInUseCase(sl()))
    ..registerLazySingleton(() => GetParcelsUseCase(sl()))
    ..registerLazySingleton(() => WatchTrackingUseCase(sl()));

  // BLoCs
  sl
    ..registerFactory(() => SplashCubit(sl()))
    ..registerFactory(() => LoginBloc(sl()))
    ..registerFactory(() => HomeBloc(sl()))
    ..registerFactory(() => ShipmentsBloc(sl()))
    ..registerFactory(() => TrackingBloc(sl()))
    ..registerFactory(() => WalletBloc(sl()))
    ..registerFactory(() => AccountBloc(sl(), sl()));
}
