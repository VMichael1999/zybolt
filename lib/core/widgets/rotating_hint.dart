import 'dart:async';

import 'package:flutter/material.dart';

import '../extensions/context_x.dart';
import '../theme/app_colors.dart';
import '../theme/app_durations.dart';
import '../theme/app_typography.dart';

/// Texto del buscador que alterna entre ejemplos con fade.
class RotatingHint extends StatefulWidget {
  const RotatingHint({super.key, required this.hints});

  final List<String> hints;

  @override
  State<RotatingHint> createState() => _RotatingHintState();
}

class _RotatingHintState extends State<RotatingHint> {
  Timer? _every;
  Timer? _swap;
  int _index = 0;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    _every = Timer.periodic(AppDurations.hintEvery, (_) {
      if (!mounted) return;
      setState(() => _opacity = 0);
      _swap = Timer(AppDurations.hintSwap, () {
        if (!mounted) return;
        setState(() {
          _index = (_index + 1) % widget.hints.length;
          _opacity = 1;
        });
      });
    });
  }

  @override
  void dispose() {
    _every?.cancel();
    _swap?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: context.reduceMotion ? Duration.zero : AppDurations.hintSwap,
      child: Text(
        widget.hints[_index],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.of(
          15,
          FontWeight.w500,
          color: AppColors.searchText,
        ),
      ),
    );
  }
}
