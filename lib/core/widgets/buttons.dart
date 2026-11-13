import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

/// Botón «Iniciar sesión»: degradado, sombra y escala 0.98 al presionar.
class GradientPillButton extends StatefulWidget {
  const GradientPillButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  State<GradientPillButton> createState() => _GradientPillButtonState();
}

class _GradientPillButtonState extends State<GradientPillButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _down ? 0.98 : 1,
        duration: const Duration(milliseconds: 90),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(28),
            boxShadow: AppShadows.button,
          ),
          child: Text(widget.label, style: AppTypography.button),
        ),
      ),
    );
  }
}

/// Botón de acceso social (Google, Apple).
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.mark,
    required this.label,
    this.onPressed,
  });

  final Widget mark;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.line),
          boxShadow: AppShadows.social,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mark,
            const SizedBox(width: 10),
            Text(label, style: AppTypography.of(15, FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    const rule = Expanded(
      child: SizedBox(height: 1, child: ColoredBox(color: AppColors.line)),
    );
    return Row(
      children: [
        rule,
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTypography.of(13, FontWeight.w500, color: AppColors.orText),
        ),
        const SizedBox(width: 12),
        rule,
      ],
    );
  }
}

/// Botón circular de ícono (blanco u oscuro), con punto opcional.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.size = 48,
    this.dark = false,
    this.badge = false,
    this.shadow = false,
    this.iconSize = 20,
    this.solidIcon = false,
    this.onPressed,
  });

  final bool solidIcon;
  final String icon;
  final String label;
  final double size;
  final bool dark;
  final bool badge;
  final bool shadow;
  final double iconSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: dark ? AppColors.dark : AppColors.white,
            shape: BoxShape.circle,
            boxShadow: shadow ? AppShadows.circleButton : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppIcon(
                icon,
                size: iconSize,
                color: dark ? AppColors.white : AppColors.ink,
                solid: solidIcon,
              ),
              if (badge)
                Positioned(
                  top: 12,
                  right: 13,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.white, spreadRadius: 2),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// «Cerrar sesión».
class OutlinePillButton extends StatelessWidget {
  const OutlinePillButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final String icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.outlineFill,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.outlineBorder, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(icon, color: AppColors.primaryDark),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.of(
                15.5,
                FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Interruptor 48 × 28.
class PillSwitch extends StatelessWidget {
  const PillSwitch({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48,
      height: 28,
      decoration: BoxDecoration(
        color: value ? AppColors.primary : AppColors.switchOff,
        borderRadius: BorderRadius.circular(14),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: AppShadows.knob,
            ),
          ),
        ),
      ),
    );
  }
}
