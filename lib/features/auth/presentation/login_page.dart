import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/blur_loading_overlay.dart';
import '../../../core/widgets/brand_wordmark.dart';
import '../../../core/widgets/buttons.dart';
import '../../../core/widgets/pill_text_field.dart';
import 'login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) context.go(Routes.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const _Hero(),
            const Positioned.fill(top: 282, child: _Sheet()),
            BlocBuilder<LoginBloc, LoginState>(
              buildWhen:
                  (a, b) =>
                      (a.status == LoginStatus.loading) !=
                      (b.status == LoginStatus.loading),
              builder:
                  (context, state) => BlurLoadingOverlay(
                    visible: state.status == LoginStatus.loading,
                    image: 'loading_truck',
                    imageWidth: 180,
                    imageHeight: 130,
                    text: 'Iniciando sesión…',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: 300,
      child: ColoredBox(
        color: AppColors.white,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 95,
              height: 205,
              child: Image(
                image: AssetImage('assets/images/login_hero.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              left: 24,
              top: 68,
              child: Row(
                children: [
                  AppImage('logo_mark', width: 32, height: 28),
                  SizedBox(width: 8),
                  BrandWordmark(
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.21,
                      color: AppColors.ink,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final bloc = context.read<LoginBloc>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Bienvenido de nuevo', style: AppTypography.welcome),
                const SizedBox(height: 20),
                PillTextField(
                  icon: 'mail',
                  hint: 'Correo o teléfono',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => bloc.add(EmailChanged(v)),
                ),
                const SizedBox(height: 12),
                PillTextField(
                  icon: 'lock',
                  hint: 'Contraseña',
                  obscure: state.obscure,
                  onChanged: (v) => bloc.add(PasswordChanged(v)),
                  trailing: _EyeButton(
                    obscure: state.obscure,
                    onTap: () => bloc.add(const PasswordVisibilityToggled()),
                  ),
                ),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      state.error!,
                      style: AppTypography.of(
                        12.5,
                        FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                _KeepRow(
                  keep: state.keepSignedIn,
                  onToggle: () => bloc.add(const KeepSignedInToggled()),
                ),
                const SizedBox(height: 18),
                GradientPillButton(
                  label: 'Iniciar sesión',
                  onPressed: () => bloc.add(const LoginSubmitted()),
                ),
                const SizedBox(height: 22),
                const OrDivider(text: 'O continúa con'),
                const SizedBox(height: 16),
                const _SocialRow(),
                const SizedBox(height: 24),
                const _SignUp(),
                const SizedBox(height: 22),
                const _Guest(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _EyeButton extends StatelessWidget {
  const _EyeButton({required this.obscure, required this.onTap});

  final bool obscure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: obscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AppIcon(
            obscure ? 'eye-off' : 'eye',
            size: 19,
            color: AppColors.fieldIcon,
          ),
        ),
      ),
    );
  }
}

class _KeepRow extends StatelessWidget {
  const _KeepRow({required this.keep, required this.onToggle});

  final bool keep;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            checked: keep,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggle,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: keep ? AppColors.primary : AppColors.white,
                      shape: BoxShape.circle,
                      border:
                          keep
                              ? null
                              : Border.all(
                                color: AppColors.checkOff,
                                width: 1.5,
                              ),
                    ),
                    child:
                        keep
                            ? const AppIcon(
                              'check',
                              size: 12,
                              color: AppColors.white,
                              strokeWidth: 3,
                            )
                            : null,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Mantener sesión iniciada',
                    style: AppTypography.of(
                      13,
                      FontWeight.w500,
                      color: AppColors.keepText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            '¿Olvidaste tu contraseña?',
            style: AppTypography.of(
              13,
              FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: SocialButton(
            label: 'Google',
            mark: Image(
              image: AssetImage('assets/images/brand_google.png'),
              width: 22,
              height: 22,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: SocialButton(
            label: 'Apple',
            mark: Image(
              image: AssetImage('assets/images/brand_apple.png'),
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _SignUp extends StatelessWidget {
  const _SignUp();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: AppTypography.of(
            13.5,
            FontWeight.w400,
            color: AppColors.signupText,
          ),
          children: [
            const TextSpan(text: '¿No tienes cuenta?'),
            TextSpan(
              text: ' Regístrate',
              style: AppTypography.of(13.5, FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _Guest extends StatelessWidget {
  const _Guest();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Rastrea como invitado',
          style: AppTypography.of(15, FontWeight.w700, color: AppColors.guest),
        ),
        const SizedBox(width: 6),
        const AppIcon('arrow-r', size: 17, color: AppColors.guest),
      ],
    );
  }
}
