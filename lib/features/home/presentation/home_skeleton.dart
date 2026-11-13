import 'package:flutter/material.dart';

import '../../../core/extensions/context_x.dart';
import '../../../core/theme/app_colors.dart';

/// Esqueleto con la misma forma de cada sección (no un spinner).
class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton({super.key});

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<HomeSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started && !context.reduceMotion) {
      _started = true;
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Opacity(
          opacity: 1 - 0.45 * Curves.easeInOut.transform(_c.value),
          child: const _Shapes(),
        );
      },
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({this.width, required this.height, this.radius = 12, this.color});

  final double? width;
  final double height;
  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _Shapes extends StatelessWidget {
  const _Shapes();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 340,
            decoration: const BoxDecoration(
              color: AppColors.headerOrange,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -30),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: _Bone(height: 58, radius: 29, color: AppColors.tile),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 2, 24, 14),
            child: _Bone(width: 110, height: 22),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (_) => const _Bone(width: 70, height: 70, radius: 20),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 30, 24, 14),
            child: _Bone(width: 150, height: 22),
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 22),
            child: Row(
              children: [
                _Bone(width: 178, height: 110, radius: 18),
                SizedBox(width: 12),
                _Bone(width: 178, height: 110, radius: 18),
                SizedBox(width: 12),
                _Bone(width: 178, height: 110, radius: 18),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 30, 24, 14),
            child: _Bone(width: 120, height: 22),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: _Bone(height: 260, radius: 20),
          ),
        ],
      ),
    );
  }
}
