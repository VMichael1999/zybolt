import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_durations.dart';
import '../core/widgets/blur_loading_overlay.dart';
import '../core/widgets/glass_nav_bar.dart';
import '../features/account/presentation/account_bloc.dart';
import '../features/account/presentation/account_page.dart';
import '../features/auth/presentation/login_bloc.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/home/presentation/home_bloc.dart';
import '../features/home/presentation/home_page.dart';
import '../features/shipments/presentation/shipments_bloc.dart';
import '../features/shipments/presentation/shipping_page.dart';
import '../features/splash/presentation/splash_cubit.dart';
import '../features/splash/presentation/splash_page.dart';
import '../features/tracking/presentation/track_package_page.dart';
import '../features/tracking/presentation/tracking_bloc.dart';
import '../features/wallet/presentation/wallet_bloc.dart';
import '../features/wallet/presentation/wallet_page.dart';
import 'di.dart';
import 'shell_scope.dart';

abstract final class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const orders = '/orders';
  static const wallet = '/wallet';
  static const account = '/account';
  static String track(String id) => '/track/$id';
}

/// Transición de pantalla: fade de 350 ms.
CustomTransitionPage<void> fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: Material(color: AppColors.white, child: child),
    transitionDuration: AppDurations.screenFade,
    reverseTransitionDuration: AppDurations.screenFade,
    transitionsBuilder: (context, animation, _, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
        child: child,
      );
    },
  );
}

const List<NavItem> _navItems = [
  NavItem(icon: 'home', label: 'Inicio'),
  NavItem(icon: 'orders', label: 'Pedidos'),
  NavItem(icon: 'wallet', label: 'Billetera'),
  NavItem(icon: 'user', label: 'Cuenta'),
];

const List<String> _tabs = [
  Routes.home,
  Routes.orders,
  Routes.wallet,
  Routes.account,
];

GoRouter createRouter() {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder:
            (context, state) => fadePage(
              state,
              BlocProvider(
                create: (_) => sl<SplashCubit>(),
                child: const SplashPage(),
              ),
            ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder:
            (context, state) => fadePage(
              state,
              BlocProvider(
                create: (_) => sl<LoginBloc>(),
                child: const LoginPage(),
              ),
            ),
      ),
      ShellRoute(
        builder:
            (context, state, child) =>
                _Shell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder:
                (context, state) => fadePage(
                  state,
                  BlocProvider(
                    create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
                    child: const HomePage(),
                  ),
                ),
          ),
          GoRoute(
            path: Routes.orders,
            pageBuilder:
                (context, state) => fadePage(
                  state,
                  BlocProvider(
                    create:
                        (_) =>
                            sl<ShipmentsBloc>()..add(const ShipmentsStarted()),
                    child: ShippingPage(
                      autoOpenParcelId: state.extra as String?,
                    ),
                  ),
                ),
          ),
          GoRoute(
            path: Routes.wallet,
            pageBuilder:
                (context, state) => fadePage(
                  state,
                  BlocProvider(
                    create: (_) => sl<WalletBloc>()..add(const WalletStarted()),
                    child: const WalletPage(),
                  ),
                ),
          ),
          GoRoute(
            path: Routes.account,
            pageBuilder:
                (context, state) => fadePage(
                  state,
                  BlocProvider(
                    create:
                        (_) => sl<AccountBloc>()..add(const AccountStarted()),
                    child: const AccountPage(),
                  ),
                ),
          ),
        ],
      ),
      GoRoute(
        path: '/track/:id',
        pageBuilder:
            (context, state) => fadePage(
              state,
              BlocProvider(
                create: (_) => sl<TrackingBloc>(),
                child: TrackPackagePage(parcelId: state.pathParameters['id']!),
              ),
            ),
      ),
    ],
  );
}

final GoRouter appRouter = createRouter();

/// Barra flotante compartida por Inicio, Pedidos, Billetera y Cuenta.
/// También aloja el overlay «Buscando tu paquete…», que cubre la barra.
class _Shell extends StatefulWidget {
  const _Shell({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  final ValueNotifier<bool> _searching = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _searching.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = _tabs.indexWhere(widget.location.startsWith);
    return ShellScope(
      searching: _searching,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Positioned.fill(child: widget.child),
            GlassNavBar(
              items: _navItems,
              currentIndex: index < 0 ? 0 : index,
              onTap: (i) => context.go(_tabs[i]),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _searching,
              builder:
                  (context, visible, _) => BlurLoadingOverlay(
                    visible: visible,
                    image: 'searching_map',
                    imageWidth: 200,
                    imageHeight: 130,
                    text: 'Buscando tu paquete…',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
