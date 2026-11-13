import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/profile_card.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/settings_group.dart';
import '../domain/account.dart';
import 'account_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listenWhen: (a, b) => !a.loggedOut && b.loggedOut,
      listener: (context, _) => context.go(Routes.login),
      child: ColoredBox(
        color: AppColors.white,
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            final profile = state.profile;
            final membership = state.membership;
            if (profile == null || membership == null) {
              return const SizedBox.expand();
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: _Body(
                    profile: profile,
                    membership: membership,
                    prefs: state.preferences,
                  ),
                ),
                const TopStatusStrip(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.profile,
    required this.membership,
    required this.prefs,
  });

  final Profile profile;
  final Membership membership;
  final Preferences prefs;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AccountBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenHeader(
          title: 'Cuenta',
          actionIcon: 'settings',
          actionLabel: 'Ajustes',
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ProfileCard(
              name: profile.name,
              email: profile.email,
              editLabel: 'Editar',
              stats: [
                ProfileStat('${profile.parcels}', 'Paquetes'),
                ProfileStat('${profile.onTimePercent}%', 'A tiempo'),
                ProfileStat('${profile.addresses}', 'Direcciones'),
              ],
              membership: membership.tier,
              membershipDetail:
                  '${membership.current} de ${membership.target} '
                  'paquetes para ${membership.nextTier}',
              progress: membership.progress,
            ),
          ),
        ),
        SettingsGroup(
          label: 'Cuenta',
          top: 22,
          children: [
            const SettingsTile(
              icon: 'user',
              title: 'Datos personales',
              first: true,
            ),
            SettingsTile(
              icon: 'pin',
              title: 'Direcciones guardadas',
              value: '${profile.addresses}',
            ),
            SettingsTile(
              icon: 'card',
              title: 'Métodos de pago',
              value: '•••• 4417',
              onTap: () => context.go(Routes.wallet),
            ),
          ],
        ),
        SettingsGroup(
          label: 'Preferencias',
          children: [
            SettingsTile(
              icon: 'bell',
              title: 'Notificaciones de entrega',
              switchValue: prefs.deliveryNotifications,
              first: true,
              onTap:
                  () => bloc.add(
                    const PreferenceToggled(
                      PreferenceKey.deliveryNotifications,
                    ),
                  ),
            ),
            SettingsTile(icon: 'globe', title: 'Idioma', value: prefs.language),
            SettingsTile(
              icon: 'moon',
              title: 'Modo oscuro',
              switchValue: prefs.darkMode,
              onTap:
                  () =>
                      bloc.add(const PreferenceToggled(PreferenceKey.darkMode)),
            ),
          ],
        ),
        const SettingsGroup(
          label: 'Soporte',
          children: [
            SettingsTile(icon: 'help', title: 'Centro de ayuda', first: true),
            SettingsTile(icon: 'shield', title: 'Privacidad y seguridad'),
            SettingsTile(icon: 'info', title: 'Acerca de Zybolt'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
          child: OutlinePillButton(
            label: 'Cerrar sesión',
            icon: 'logout',
            onPressed: () => bloc.add(const LogoutRequested()),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            'Versión 1.0.0',
            style: AppTypography.of(12, FontWeight.w400, color: AppColors.ink3),
          ),
        ),
      ],
    );
  }
}
