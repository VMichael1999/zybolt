import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

enum TransactionTone { shipping, income, neutral }

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    required this.detail,
    required this.amount,
    required this.income,
    this.first = false,
  });

  final String icon;
  final TransactionTone tone;
  final String title;
  final String detail;
  final String amount;
  final bool income;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    switch (tone) {
      case TransactionTone.shipping:
        bg = AppColors.transitBg;
        fg = AppColors.primary;
      case TransactionTone.income:
        bg = AppColors.greenSoft;
        fg = AppColors.green;
      case TransactionTone.neutral:
        bg = AppColors.tile;
        fg = AppColors.iconBoxFg;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        border:
            first
                ? null
                : const Border(top: BorderSide(color: AppColors.lineSoft)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(13),
            ),
            child: AppIcon(icon, color: fg),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.of(14, FontWeight.w700)),
                const SizedBox(height: 1),
                Text(
                  detail,
                  style: AppTypography.of(
                    12,
                    FontWeight.w500,
                    color: AppColors.metaGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            textAlign: TextAlign.right,
            style: AppTypography.of(
              14.5,
              FontWeight.w800,
              color: income ? AppColors.green : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// Etiqueta de grupo («Hoy») y tarjeta con filas.
class TransactionGroup extends StatelessWidget {
  const TransactionGroup({
    super.key,
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupLabel(label),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class GroupLabel extends StatelessWidget {
  const GroupLabel(this.text, {super.key, this.top = 18});

  final String text;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22, top, 22, 8),
      child: Text(
        text,
        style: AppTypography.of(
          12.5,
          FontWeight.w700,
          color: AppColors.groupLabel,
        ),
      ),
    );
  }
}
