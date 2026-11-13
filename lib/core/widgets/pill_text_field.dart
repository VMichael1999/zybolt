import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_durations.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

class PillTextField extends StatefulWidget {
  const PillTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.obscure = false,
    this.trailing,
    this.onChanged,
    this.keyboardType,
    this.controller,
  });

  final String icon;
  final String hint;
  final bool obscure;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  State<PillTextField> createState() => _PillTextFieldState();
}

class _PillTextFieldState extends State<PillTextField> {
  final FocusNode _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.fieldFocus,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: _focused ? AppColors.focusFill : AppColors.field,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _focused ? AppColors.focusBorder : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          AppIcon(widget.icon, size: 19, color: AppColors.fieldIcon),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              focusNode: _focus,
              controller: widget.controller,
              obscureText: widget.obscure,
              onChanged: widget.onChanged,
              keyboardType: widget.keyboardType,
              cursorColor: AppColors.primary,
              style: AppTypography.body,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.fieldHint,
                ),
              ),
            ),
          ),
          if (widget.trailing != null)
            Transform.translate(
              offset: const Offset(6, 0),
              child: widget.trailing,
            ),
        ],
      ),
    );
  }
}
