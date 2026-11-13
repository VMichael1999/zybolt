import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/context_x.dart';
import '../theme/app_colors.dart';
import '../theme/app_durations.dart';
import '../theme/app_typography.dart';
import 'app_image.dart';

/// Overlay con desenfoque: ilustración que sube y baja, y un texto.
class BlurLoadingOverlay extends StatelessWidget {
  const BlurLoadingOverlay({
    super.key,
    required this.visible,
    required this.image,
    required this.imageWidth,
    required this.imageHeight,
    required this.text,
  });

  final bool visible;
  final String image;
  final double imageWidth;
  final double imageHeight;
  final String text;

  @override
  Widget build(BuildContext context) {
    final reduce = context.reduceMotion;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: visible ? 1 : 0),
      duration: reduce ? Duration.zero : AppDurations.overlay,
      builder: (context, t, child) {
        if (t == 0) return const SizedBox.shrink();
        return Positioned.fill(
          child: IgnorePointer(
            ignoring: !visible,
            child: Opacity(opacity: t, child: child),
          ),
        );
      },
      child: Semantics(
        liveRegion: true,
        label: text,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: ColoredBox(
              color: AppColors.white.withValues(alpha: 0.55),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Bob(
                      enabled: !reduce,
                      child: AppImage(
                        image,
                        width: imageWidth,
                        height: imageHeight,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(text, style: AppTypography.of(15, FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bob extends StatefulWidget {
  const _Bob({required this.child, required this.enabled});

  final Widget child;
  final bool enabled;

  @override
  State<_Bob> createState() => _BobState();
}

class _BobState extends State<_Bob> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppDurations.bob,
  );

  @override
  void initState() {
    super.initState();
    if (widget.enabled) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _c, curve: Curves.easeInOut),
      builder: (context, child) {
        final v = Curves.easeInOut.transform(_c.value);
        return Transform.translate(offset: Offset(0, -3 + 6 * v), child: child);
      },
      child: widget.child,
    );
  }
}
