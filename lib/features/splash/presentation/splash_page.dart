import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/extensions/context_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/brand_wordmark.dart';
import 'splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppDurations.splash,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final reduce = context.reduceMotion;
    if (reduce) {
      _c.value = 1;
    } else {
      _c.forward();
    }
    context.read<SplashCubit>().start(reduceMotion: reduce);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// Interpola entre dos fotogramas clave (0 → 55 % → 100 %), aplicando la
  /// curva en cada tramo como hace CSS.
  double _keyframes(double t, double mid, double end, Curve curve) {
    if (t < 0.55) return mid * curve.transform(t / 0.55);
    final local = curve.transform((t - 0.55) / 0.45);
    return mid + (end - mid) * local;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (a, b) => !a.finished && b.finished,
      listener:
          (context, state) =>
              context.go(state.hasSession ? Routes.home : Routes.login),
      child: ColoredBox(
        color: AppColors.white,
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;
            return AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final t = _c.value;
                final roadAngle =
                    _keyframes(t, 40, 45, AppCurves.splash) * math.pi / 180;
                final shift = _keyframes(t, 30, 70, AppCurves.splash);
                final tilt = _keyframes(t, 40, 45, Curves.ease) * math.pi / 180;
                final brand = const Interval(
                  1100 / 3200,
                  1800 / 3200,
                  curve: Curves.ease,
                ).transform(t);
                return Stack(
                  children: [
                    Positioned(
                      left: (w - 560) / 2,
                      top: 50,
                      width: 560,
                      height: 560,
                      child: ShaderMask(
                        blendMode: BlendMode.dstIn,
                        shaderCallback:
                            (rect) => const RadialGradient(
                              radius: 0.7071,
                              colors: [
                                AppColors.black,
                                AppColors.black,
                                AppColors.transparent,
                              ],
                              stops: [0, 0.30, 0.62],
                            ).createShader(rect),
                        child: Transform(
                          alignment: Alignment.center,
                          transform:
                              Matrix4.identity()
                                ..rotateZ(roadAngle)
                                ..translateByDouble(0.0, shift, 0.0, 1.0),
                          child: const AppImage(
                            'splash_map',
                            width: 560,
                            height: 560,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w / 2 - 35,
                      top: 270,
                      width: 70,
                      height: 120,
                      child: Transform.rotate(
                        angle: tilt,
                        child: const AppImage(
                          'splash_scooter',
                          width: 70,
                          height: 120,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 590,
                      child: Opacity(
                        opacity: brand,
                        child: Transform.translate(
                          offset: Offset(0, 8 * (1 - brand)),
                          child: const _Brand(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandWordmark(style: AppTypography.display),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 270),
          child: Text(
            'Envía, rastrea y entrega lo que sea en tu ciudad, '
            'en pocos toques.',
            textAlign: TextAlign.center,
            style: AppTypography.of(
              15,
              FontWeight.w400,
              color: AppColors.splashTagline,
            ).copyWith(height: 1.45),
          ),
        ),
      ],
    );
  }
}
