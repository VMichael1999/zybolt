import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/widgets/buttons.dart';
import '../domain/home.dart';
import 'home_bloc.dart';
import 'home_header.dart';
import 'home_search_bar.dart';
import 'home_sections.dart';
import 'home_skeleton.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final summary = state.summary;
          if (summary == null) return const HomeSkeleton();
          return _HomeContent(summary: summary);
        },
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({required this.summary});

  final HomeSummary summary;

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  static const double _threshold = 210;

  final ScrollController _controller = ScrollController();
  bool _compact = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final compact = _controller.offset > _threshold;
      if (compact != _compact) setState(() => _compact = compact);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openTracking() {
    context.go(Routes.orders, extra: 'D314315783');
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    return Stack(
      children: [
        CustomScrollView(
          controller: _controller,
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      HomeHeader(
                        summary: summary,
                        onOpenTracking: _openTracking,
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                  const Positioned(
                    left: 22,
                    right: 22,
                    bottom: 0,
                    height: 58,
                    child: HomeSearchBar(),
                  ),
                ],
              ),
            ),
            for (final section in kHomeSections)
              SliverToBoxAdapter(child: section.build(context, summary)),
            const SliverToBoxAdapter(child: SizedBox(height: 150)),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _CompactHeader(visible: _compact),
        ),
      ],
    );
  }
}

class _CompactHeader extends StatelessWidget {
  const _CompactHeader({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, -1.1),
      duration: AppDurations.compactHeader,
      curve: AppCurves.compactHeader,
      child: Container(
        height: 124,
        padding: const EdgeInsets.fromLTRB(18, 62, 18, 0),
        decoration: const BoxDecoration(
          color: AppColors.headerOrange,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          boxShadow: AppShadows.compactHeader,
        ),
        child: const Row(
          children: [
            UserAvatar(size: 42),
            SizedBox(width: 10),
            Expanded(child: HomeSearchBar(height: 48, shadow: false)),
            SizedBox(width: 10),
            CircleIconButton(
              icon: 'bell',
              label: 'Notificaciones',
              size: 44,
              badge: true,
            ),
          ],
        ),
      ),
    );
  }
}
