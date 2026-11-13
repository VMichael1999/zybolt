import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';
import 'buttons.dart';
import 'transaction_tile.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    required this.label,
    required this.children,
    this.top = 18,
  });

  final String label;
  final List<Widget> children;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupLabel(label, top: top),
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

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.switchValue,
    this.first = false,
    this.onTap,
  });

  final String icon;
  final String title;
  final String? value;

  /// Si no es nulo, la fila muestra un interruptor.
  final bool? switchValue;
  final bool first;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: switchValue,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border:
                first
                    ? null
                    : const Border(top: BorderSide(color: AppColors.lineSoft)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.tile,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: AppIcon(icon, size: 19, color: AppColors.iconBoxFg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.of(14.5, FontWeight.w600),
                ),
              ),
              if (switchValue != null)
                PillSwitch(value: switchValue!)
              else ...[
                if (value != null)
                  Text(
                    value!,
                    style: AppTypography.of(
                      13,
                      FontWeight.w500,
                      color: AppColors.metaGrey,
                    ),
                  ),
                const SizedBox(width: 4),
                const AppIcon('chev-r', size: 16, color: AppColors.chevronSoft),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
