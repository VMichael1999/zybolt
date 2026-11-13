import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zybolt/app/di.dart';
import 'package:zybolt/app/shell_scope.dart';
import 'package:zybolt/core/widgets/glass_nav_bar.dart';
import 'package:zybolt/features/account/presentation/account_bloc.dart';
import 'package:zybolt/features/account/presentation/account_page.dart';
import 'package:zybolt/features/auth/presentation/login_bloc.dart';
import 'package:zybolt/features/auth/presentation/login_page.dart';
import 'package:zybolt/features/home/presentation/home_bloc.dart';
import 'package:zybolt/features/home/presentation/home_page.dart';
import 'package:zybolt/features/shipments/presentation/shipments_bloc.dart';
import 'package:zybolt/features/shipments/presentation/shipping_page.dart';
import 'package:zybolt/features/splash/presentation/splash_cubit.dart';
import 'package:zybolt/features/splash/presentation/splash_page.dart';
import 'package:zybolt/features/tracking/domain/tracking.dart';
import 'package:zybolt/features/tracking/presentation/track_package_page.dart';
import 'package:zybolt/features/tracking/presentation/tracking_bloc.dart';
import 'package:zybolt/features/wallet/presentation/wallet_bloc.dart';
import 'package:zybolt/features/wallet/presentation/wallet_page.dart';

import '../helpers/golden_helpers.dart';

const List<NavItem> _items = [
  NavItem(icon: 'home', label: 'Inicio'),
  NavItem(icon: 'orders', label: 'Pedidos'),
  NavItem(icon: 'wallet', label: 'Billetera'),
  NavItem(icon: 'user', label: 'Cuenta'),
];

/// Pantalla con la barra flotante, como en el ShellRoute.
Widget _shell(Widget page, int index) {
  return ShellScope(
    searching: ValueNotifier<bool>(false),
    child: Stack(
      children: [
        Positioned.fill(child: page),
        GlassNavBar(items: _items, currentIndex: index, onTap: (_) {}),
      ],
    ),
  );
}

class _FixedTracking implements TrackingRepository {
  _FixedTracking(this.snapshot);

  final TrackingSnapshot snapshot;

  @override
  Stream<TrackingSnapshot> watch(String parcelId, {bool instant = false}) =>
      Stream.value(snapshot);
}

void main() {
  setUpAll(() async {
    await loadFonts();
    await setupDi();
  });

  Future<void> shoot(WidgetTester t, Widget w, String name) async {
    await setScreenSize(t);
    await t.pumpWidget(screenHost(w));
    await t.pump(const Duration(seconds: 1));
    await t.pump(const Duration(seconds: 1));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screens/$name.png'),
    );
  }

  testWidgets('Splash (último cuadro)', (t) async {
    await setScreenSize(t);
    await t.pumpWidget(
      screenHost(
        BlocProvider(
          create: (_) => sl<SplashCubit>(),
          child: const SplashPage(),
        ),
      ),
    );
    await t.pump(const Duration(milliseconds: 1400));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screens/splash.png'),
    );
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 1));
  });

  testWidgets('Login', (t) async {
    await shoot(
      t,
      BlocProvider(create: (_) => sl<LoginBloc>(), child: const LoginPage()),
      'login',
    );
  });

  testWidgets('Home arriba', (t) async {
    await shoot(
      t,
      _shell(
        BlocProvider(
          create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
          child: const HomePage(),
        ),
        0,
      ),
      'home_top',
    );
  });

  testWidgets('Home con cabecera compacta', (t) async {
    await setScreenSize(t);
    await t.pumpWidget(
      screenHost(
        _shell(
          BlocProvider(
            create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
            child: const HomePage(),
          ),
          0,
        ),
      ),
    );
    await t.pump(const Duration(seconds: 1));
    await t.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await t.pump(const Duration(seconds: 1));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screens/home_compact.png'),
    );
  });

  testWidgets('Home abajo', (t) async {
    await setScreenSize(t);
    await t.pumpWidget(
      screenHost(
        _shell(
          BlocProvider(
            create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
            child: const HomePage(),
          ),
          0,
        ),
      ),
    );
    await t.pump(const Duration(seconds: 1));
    await t.drag(find.byType(CustomScrollView), const Offset(0, -3000));
    await t.pump(const Duration(seconds: 1));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screens/home_bottom.png'),
    );
  });

  testWidgets('Mis envíos', (t) async {
    await shoot(
      t,
      _shell(
        BlocProvider(
          create: (_) => sl<ShipmentsBloc>()..add(const ShipmentsStarted()),
          child: const ShippingPage(),
        ),
        1,
      ),
      'orders',
    );
  });

  for (final entry
      in {
        'packed': TrackingSnapshot.at(0.1),
        'transit': TrackingSnapshot.at(0.6),
        'delivered': TrackingSnapshot.delivered(),
      }.entries) {
    testWidgets('Seguimiento ${entry.key}', (t) async {
      await shoot(
        t,
        BlocProvider(
          create:
              (_) => TrackingBloc(
                WatchTrackingUseCase(_FixedTracking(entry.value)),
              ),
          child: const TrackPackagePage(parcelId: 'D314315783'),
        ),
        'track_${entry.key}',
      );
    });
  }

  testWidgets('Billetera', (t) async {
    await shoot(
      t,
      _shell(
        BlocProvider(
          create: (_) => sl<WalletBloc>()..add(const WalletStarted()),
          child: const WalletPage(),
        ),
        2,
      ),
      'wallet_top',
    );
  });

  testWidgets('Billetera con scroll', (t) async {
    await setScreenSize(t);
    await t.pumpWidget(
      screenHost(
        _shell(
          BlocProvider(
            create: (_) => sl<WalletBloc>()..add(const WalletStarted()),
            child: const WalletPage(),
          ),
          2,
        ),
      ),
    );
    await t.pump(const Duration(seconds: 1));
    await t.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -2000),
    );
    await t.pump(const Duration(seconds: 1));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screens/wallet_scrolled.png'),
    );
  });

  testWidgets('Cuenta', (t) async {
    await shoot(
      t,
      _shell(
        BlocProvider(
          create: (_) => sl<AccountBloc>()..add(const AccountStarted()),
          child: const AccountPage(),
        ),
        3,
      ),
      'account',
    );
  });
}
