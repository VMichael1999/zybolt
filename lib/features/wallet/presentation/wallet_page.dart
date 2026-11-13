import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/balance_card.dart';
import '../../../core/widgets/horizontal_cards.dart';
import '../../../core/widgets/mini_stat_card.dart';
import '../../../core/widgets/payment_method_card.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/transaction_tile.dart';
import '../domain/wallet.dart';
import 'wallet_bloc.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          final summary = state.summary;
          if (summary == null) return const SizedBox.expand();
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 150),
                child: _Body(summary: summary, hidden: state.balanceHidden),
              ),
              const TopStatusStrip(),
            ],
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.summary, required this.hidden});

  final WalletSummary summary;
  final bool hidden;

  static String _dayLabel(TransactionDay d) =>
      d == TransactionDay.today ? 'Hoy' : 'Ayer';

  static (String, TransactionTone) _icon(TransactionKind k) {
    switch (k) {
      case TransactionKind.shipping:
        return ('truck', TransactionTone.shipping);
      case TransactionKind.topUp:
        return ('plus', TransactionTone.income);
      case TransactionKind.parcel:
        return ('box', TransactionTone.neutral);
      case TransactionKind.refund:
        return ('down', TransactionTone.income);
      case TransactionKind.cashback:
        return ('gift', TransactionTone.neutral);
    }
  }

  @override
  Widget build(BuildContext context) {
    final month = summary.month;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenHeader(
          title: 'Billetera',
          actionIcon: 'plus',
          actionLabel: 'Agregar fondos',
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: BalanceCard(
              title: 'Saldo disponible',
              amount: hidden ? '••••••' : Fmt.money(summary.balance),
              hidden: hidden,
              meta: 'Zybolt Pay · Actualizado ${summary.updatedAt}',
              todayLabel: '+\$${summary.todayDelta.toStringAsFixed(0)} hoy',
              showLabel: 'Mostrar saldo',
              hideLabel: 'Ocultar saldo',
              onToggleVisibility:
                  () => context.read<WalletBloc>().add(
                    const BalanceVisibilityToggled(),
                  ),
              actions: const [
                QuickActionButton(
                  icon: 'plus',
                  label: 'Recargar',
                  primary: true,
                ),
                QuickActionButton(icon: 'up', label: 'Pagar'),
                QuickActionButton(icon: 'swap', label: 'Transferir'),
                QuickActionButton(icon: 'dots', label: 'Más'),
              ],
            ),
          ),
        ),
        const SectionHeader(title: 'Métodos de pago', action: 'Gestionar'),
        HorizontalCards(
          children: [
            for (final m in summary.methods)
              PaymentMethodCard(
                number: m.number,
                detail: m.detail,
                dark: m.kind == PaymentMethodKind.debit,
                badge: m.isDefault ? 'Principal' : null,
                gradient:
                    m.kind == PaymentMethodKind.credit
                        ? PaymentMethodCard.orangeChip
                        : null,
              ),
            const AddMethodCard(label: 'Agregar'),
          ],
        ),
        const SectionHeader(title: 'Este mes'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Expanded(
                child: MiniStatCard(
                  icon: 'receipt',
                  iconColor: AppColors.primary,
                  value: Fmt.money(month.spent),
                  label: 'Gastado',
                  peach: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MiniStatCard(
                  icon: 'down',
                  iconColor: AppColors.green,
                  value: Fmt.money(month.refunds),
                  label: 'Reembolsos',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MiniStatCard(
                  icon: 'gift',
                  iconColor: AppColors.progressDot,
                  value: Fmt.money(month.cashback),
                  label: 'Cashback',
                ),
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Movimientos', action: 'Ver todo'),
        for (final g in summary.groups)
          TransactionGroup(
            label: _dayLabel(g.day),
            children: [
              for (var i = 0; i < g.items.length; i++)
                TransactionTile(
                  icon: _icon(g.items[i].kind).$1,
                  tone: _icon(g.items[i].kind).$2,
                  title: g.items[i].title,
                  detail: g.items[i].detail,
                  amount: Fmt.money(g.items[i].amount, sign: true),
                  income: g.items[i].isIncome,
                  first: i == 0,
                ),
            ],
          ),
      ],
    );
  }
}
