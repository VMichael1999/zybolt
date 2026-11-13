import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class FilterChipData {
  const FilterChipData({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
}

class FilterChipBar extends StatelessWidget {
  const FilterChipBar({super.key, required this.chips});

  final List<FilterChipData> chips;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => _Chip(chips[i]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.data);

  final FilterChipData data;

  @override
  Widget build(BuildContext context) {
    final on = data.selected;
    return Semantics(
      button: true,
      selected: on,
      child: GestureDetector(
        onTap: data.onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: on ? AppColors.dark : AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: on ? AppColors.dark : AppColors.line),
          ),
          child: Row(
            children: [
              Text(
                data.label,
                style: AppTypography.of(
                  14.5,
                  FontWeight.w600,
                  color: on ? AppColors.white : AppColors.ink,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(minWidth: 20),
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: on ? AppColors.countBgDark : AppColors.countBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${data.count}',
                  style: AppTypography.of(
                    11.5,
                    FontWeight.w700,
                    color: on ? AppColors.white : AppColors.countFg,
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
