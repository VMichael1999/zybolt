import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zybolt/core/theme/app_colors.dart';
import 'package:zybolt/core/widgets/active_shipment_card.dart';
import 'package:zybolt/core/widgets/balance_card.dart';
import 'package:zybolt/core/widgets/booking_card.dart';
import 'package:zybolt/core/widgets/buttons.dart';
import 'package:zybolt/core/widgets/courier_header.dart';
import 'package:zybolt/core/widgets/delivery_status_banner.dart';
import 'package:zybolt/core/widgets/drop_off.dart';
import 'package:zybolt/core/widgets/filter_chip_bar.dart';
import 'package:zybolt/core/widgets/flag_pair.dart';
import 'package:zybolt/core/widgets/glass_nav_bar.dart';
import 'package:zybolt/core/widgets/mini_stat_card.dart';
import 'package:zybolt/core/widgets/parcel_card.dart';
import 'package:zybolt/core/widgets/payment_method_card.dart';
import 'package:zybolt/core/widgets/pill_text_field.dart';
import 'package:zybolt/core/widgets/profile_card.dart';
import 'package:zybolt/core/widgets/section_header.dart';
import 'package:zybolt/core/widgets/service_tile.dart';
import 'package:zybolt/core/widgets/settings_group.dart';
import 'package:zybolt/core/widgets/shipment_stepper.dart';
import 'package:zybolt/core/widgets/stat_cards.dart';
import 'package:zybolt/core/widgets/status_pill.dart';
import 'package:zybolt/core/widgets/transaction_tile.dart';
import 'package:zybolt/core/widgets/update_timeline_tile.dart';

import '../helpers/golden_helpers.dart';

void main() {
  setUpAll(loadFonts);

  Future<void> shoot(
    WidgetTester tester,
    String name,
    Widget child, {
    Size size = const Size(440, 400),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(componentHost(child));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('components/$name.png'),
    );
  }

  testWidgets('PillTextField', (t) async {
    await shoot(
      t,
      'pill_text_field',
      const Column(
        children: [
          PillTextField(icon: 'mail', hint: 'Correo o teléfono'),
          SizedBox(height: 12),
          PillTextField(icon: 'lock', hint: 'Contraseña', obscure: true),
        ],
      ),
      size: const Size(440, 200),
    );
  });

  testWidgets('Botones', (t) async {
    await shoot(
      t,
      'buttons',
      const Column(
        children: [
          GradientPillButton(label: 'Iniciar sesión'),
          SizedBox(height: 12),
          OrDivider(text: 'O continúa con'),
          SizedBox(height: 12),
          SocialButton(mark: SizedBox(), label: 'Google'),
          SizedBox(height: 12),
          OutlinePillButton(label: 'Cerrar sesión', icon: 'logout'),
          SizedBox(height: 12),
          Row(
            children: [
              CircleIconButton(icon: 'bell', label: 'Notificaciones', size: 46),
              SizedBox(width: 10),
              CircleIconButton(
                icon: 'arrow-ur',
                label: 'Abrir',
                size: 54,
                dark: true,
              ),
              SizedBox(width: 10),
              PillSwitch(value: true),
              SizedBox(width: 10),
              PillSwitch(value: false),
            ],
          ),
        ],
      ),
      size: const Size(440, 460),
    );
  });

  testWidgets('StatusPill y SectionHeader', (t) async {
    await shoot(
      t,
      'status_pill_section',
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusPill(label: 'En camino'),
          SizedBox(height: 8),
          StatusPill(label: 'En camino', variant: StatusPillVariant.inTransit),
          SizedBox(height: 8),
          StatusPill(label: 'Entregado', variant: StatusPillVariant.delivered),
          SectionHeader(title: 'Envíos activos', action: 'Ver todo'),
        ],
      ),
      size: const Size(440, 220),
    );
  });

  testWidgets('ServiceTile y FlagPair', (t) async {
    await shoot(
      t,
      'service_flag',
      const Row(
        children: [
          ServiceTile(image: 'service_ride', label: 'Viaje'),
          SizedBox(width: 10),
          ServiceTile(image: 'service_transit', label: 'Bus', imageSize: 52),
          SizedBox(width: 10),
          FlagPair(first: 'flag_de', second: 'flag_fr', ring: AppColors.white),
        ],
      ),
      size: const Size(440, 160),
    );
  });

  testWidgets('ActiveShipmentCard y StatCards', (t) async {
    await shoot(
      t,
      'active_shipment_stats',
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActiveShipmentCard(
            flagA: 'flag_de',
            flagB: 'flag_fr',
            statusLabel: 'En camino',
            delivered: false,
            from: 'Berlín',
            to: 'París',
            order: 'Orden DE-586340',
          ),
          SizedBox(height: 12),
          WeeklyStatCard(
            title: 'Paquetes enviados',
            range: '19 – 25 oct',
            total: '32',
            delta: '+18%',
            bars: [
              WeeklyBar(label: 'L', height: 44),
              WeeklyBar(label: 'M', height: 66),
              WeeklyBar(label: 'S', height: 86, highlight: true, value: '7'),
              WeeklyBar(label: 'D', height: 3, muted: true),
            ],
          ),
        ],
      ),
      size: const Size(440, 520),
    );
  });

  testWidgets('UpdateTimelineTile y DropOffTile', (t) async {
    await shoot(
      t,
      'timeline_dropoff',
      const Column(
        children: [
          UpdateTimelineTile(
            time: '10:24',
            title: 'En reparto',
            detail: 'AB-889641 · a 3 paradas',
            icon: 'truck',
            kind: UpdateKind.live,
            active: true,
          ),
          UpdateTimelineTile(
            time: 'Ayer',
            title: 'Entregado',
            detail: 'IT-229481 · Firmado por Lucas',
            icon: 'circle-check',
            kind: UpdateKind.success,
            timeMuted: true,
            isLast: true,
          ),
          DropOffTile(
            number: 1,
            name: 'Punto Central Mall',
            detail: 'Local G-12, planta baja',
            status: 'Abierto · Hasta las 22:00',
            distance: '0.8 km',
            open: true,
          ),
          DropOffTile(
            number: 3,
            name: 'Centro Riverside',
            detail: 'Unidad 3, Parque Riverside',
            status: 'Cerrado · Abre a las 08:00',
            distance: '2.6 km',
            open: false,
          ),
        ],
      ),
      size: const Size(440, 420),
    );
  });

  testWidgets('NearbyMap', (t) async {
    await shoot(
      t,
      'nearby_map',
      const NearbyMap(openLabel: '2 abiertos cerca de ti'),
      size: const Size(440, 240),
    );
  });

  testWidgets('ShipmentStepper', (t) async {
    await shoot(
      t,
      'shipment_stepper',
      const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            ShipmentStepper(current: 2, awayLabel: 'A 4 h'),
            SizedBox(height: 50),
            ShipmentStepper(current: 4),
            SizedBox(height: 50),
            ShipmentStepper(current: 0, awayLabel: 'A 3 d'),
          ],
        ),
      ),
      size: const Size(440, 300),
    );
  });

  testWidgets('ParcelCard (cinta)', (t) async {
    await shoot(
      t,
      'parcel_card',
      const ParcelCard(
        id: 'D314315783',
        name: 'Audífonos Studio',
        image: 'product_headphones',
        ribbonLabel: 'En camino',
        ribbonColor: AppColors.ribbonTransit,
        current: 2,
        awayLabel: 'A 4 h',
        fromLabel: 'DE',
        toLabel: 'PARA',
        from: 'Sr. Quispe',
        fromDate: '18 oct 25',
        to: 'Miraflores, Lima',
        toDate: 'Estimado 19 oct 26',
      ),
      size: const Size(440, 320),
    );
  });

  testWidgets('FilterChipBar', (t) async {
    await shoot(
      t,
      'filter_chip_bar',
      FilterChipBar(
        chips: [
          FilterChipData(
            label: 'Todos',
            count: 5,
            selected: true,
            onTap: () {},
          ),
          FilterChipData(
            label: 'En camino',
            count: 2,
            selected: false,
            onTap: () {},
          ),
          FilterChipData(
            label: 'En proceso',
            count: 2,
            selected: false,
            onTap: () {},
          ),
        ],
      ),
      size: const Size(440, 110),
    );
  });

  testWidgets('CourierHeader y DeliveryStatusBanner', (t) async {
    await shoot(
      t,
      'courier_banner',
      const Column(
        children: [
          CourierHeader(
            role: 'Reparto',
            rating: '4.8',
            name: 'Dana Reid',
            callLabel: 'Llamar',
            chatLabel: 'Chat',
          ),
          SizedBox(height: 16),
          DeliveryStatusBanner(
            variant: BannerVariant.packed,
            text: 'Empacado · llega en 8 min',
            data: 'faltan 5.2 km',
          ),
          SizedBox(height: 10),
          DeliveryStatusBanner(
            variant: BannerVariant.transit,
            text: 'En camino · llega en 3 min',
            data: 'faltan 2.0 km',
          ),
          SizedBox(height: 10),
          DeliveryStatusBanner(
            variant: BannerVariant.delivered,
            text: 'Entregado a Amelia',
            data: 'Firmado',
          ),
        ],
      ),
      size: const Size(440, 330),
    );
  });

  testWidgets('BookingCard', (t) async {
    await shoot(
      t,
      'booking_card',
      const BookingCard(
        title: 'Reserva',
        chip: 'Tránsito',
        number: 'M87952264',
        current: 2,
        awayLabel: 'A 3 min',
        cells: [
          ('Origen', 'Larcomar, Miraflores'),
          ('Destino', 'Miraflores, Lima'),
          ('Costo del pedido', '\$164.00'),
          ('Cliente', 'Amelia'),
        ],
      ),
      size: const Size(440, 380),
    );
  });

  testWidgets('BalanceCard', (t) async {
    await shoot(
      t,
      'balance_card',
      BalanceCard(
        title: 'Saldo disponible',
        amount: '\$1,280.87',
        hidden: false,
        meta: 'Zybolt Pay · Actualizado 2:32',
        todayLabel: '+\$100 hoy',
        showLabel: 'Mostrar',
        hideLabel: 'Ocultar',
        onToggleVisibility: () {},
        actions: const [
          QuickActionButton(icon: 'plus', label: 'Recargar', primary: true),
          QuickActionButton(icon: 'up', label: 'Pagar'),
          QuickActionButton(icon: 'swap', label: 'Transferir'),
          QuickActionButton(icon: 'dots', label: 'Más'),
        ],
      ),
      size: const Size(440, 320),
    );
  });

  testWidgets('PaymentMethodCard y MiniStatCard', (t) async {
    await shoot(
      t,
      'payment_ministat',
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PaymentMethodCard(
                number: '•••• 4417',
                detail: 'Débito · Vence 08/28',
                dark: true,
                badge: 'Principal',
              ),
              SizedBox(width: 12),
              AddMethodCard(label: 'Agregar'),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MiniStatCard(
                  icon: 'receipt',
                  iconColor: AppColors.primary,
                  value: '\$186.40',
                  label: 'Gastado',
                  peach: true,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: MiniStatCard(
                  icon: 'down',
                  iconColor: AppColors.green,
                  value: '\$24.00',
                  label: 'Reembolsos',
                ),
              ),
            ],
          ),
        ],
      ),
      size: const Size(440, 330),
    );
  });

  testWidgets('TransactionTile, ProfileCard y SettingsGroup', (t) async {
    await shoot(
      t,
      'transactions_profile_settings',
      const Column(
        children: [
          TransactionGroup(
            label: 'Hoy',
            children: [
              TransactionTile(
                icon: 'truck',
                tone: TransactionTone.shipping,
                title: 'Costo de envío',
                detail: 'AB-889641 · 10:24',
                amount: '−\$18.50',
                income: false,
                first: true,
              ),
              TransactionTile(
                icon: 'plus',
                tone: TransactionTone.income,
                title: 'Recarga',
                detail: 'Tarjeta de débito •••• 4417 · 09:02',
                amount: '+\$100.00',
                income: true,
              ),
            ],
          ),
          SizedBox(height: 16),
          ProfileCard(
            name: 'Michael Dev',
            email: 'michaeldev@gmail.com',
            editLabel: 'Editar',
            stats: [
              ProfileStat('128', 'Paquetes'),
              ProfileStat('98%', 'A tiempo'),
              ProfileStat('3', 'Direcciones'),
            ],
            membership: 'Miembro Oro',
            membershipDetail: '72 de 100 paquetes para Platino',
            progress: 0.72,
          ),
          SettingsGroup(
            label: 'Preferencias',
            children: [
              SettingsTile(
                icon: 'bell',
                title: 'Notificaciones de entrega',
                switchValue: true,
                first: true,
              ),
              SettingsTile(icon: 'globe', title: 'Idioma', value: 'Español'),
            ],
          ),
        ],
      ),
      size: const Size(440, 760),
    );
  });

  testWidgets('GlassNavBar', (t) async {
    t.view.physicalSize = const Size(440, 140);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      screenHost(
        GlassNavBar(
          currentIndex: 0,
          onTap: (_) {},
          items: const [
            NavItem(icon: 'home', label: 'Inicio'),
            NavItem(icon: 'orders', label: 'Pedidos'),
            NavItem(icon: 'wallet', label: 'Billetera'),
            NavItem(icon: 'user', label: 'Cuenta'),
          ],
        ),
      ),
    );
    await t.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('components/glass_nav_bar.png'),
    );
  });
}
