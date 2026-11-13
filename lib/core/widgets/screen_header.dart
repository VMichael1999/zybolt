import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';

/// Cabecera de Billetera y Cuenta: título y botón blanco de 48.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.actionIcon,
    required this.actionLabel,
    this.onAction,
    this.child,
  });

  final String title;
  final String actionIcon;
  final String actionLabel;
  final VoidCallback? onAction;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 70, 22, 6),
      decoration: const BoxDecoration(gradient: AppColors.shippingGradient),
      child: Column(
        children: [
          ScreenTitleRow(
            title: title,
            actionIcon: actionIcon,
            actionLabel: actionLabel,
            onAction: onAction,
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class ScreenTitleRow extends StatelessWidget {
  const ScreenTitleRow({
    super.key,
    required this.title,
    required this.actionIcon,
    required this.actionLabel,
    this.onAction,
  });

  final String title;
  final String actionIcon;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.title),
        CircleIconButton(
          icon: actionIcon,
          label: actionLabel,
          onPressed: onAction,
        ),
      ],
    );
  }
}

/// Franja fija de 76 que evita que el contenido pase bajo la barra de estado.
class TopStatusStrip extends StatelessWidget {
  const TopStatusStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: 76,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.topStrip,
                AppColors.topStrip,
                AppColors.topStripFade,
              ],
              stops: [0, 56 / 76, 1],
            ),
          ),
        ),
      ),
    );
  }
}
