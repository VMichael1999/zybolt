import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/shell_scope.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/filter_chip_bar.dart';
import '../../../core/widgets/parcel_card.dart';
import '../../../core/widgets/screen_header.dart';
import '../domain/shipments.dart';
import 'parcel_status_style.dart';
import 'shipments_bloc.dart';

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key, this.autoOpenParcelId});

  /// Si viene del Home, abre el seguimiento tras la búsqueda.
  final String? autoOpenParcelId;

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  Timer? _timer;
  ValueNotifier<bool>? _searching;

  @override
  void initState() {
    super.initState();
    final id = widget.autoOpenParcelId;
    if (id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openTrack(id);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    final searching = _searching;
    if (searching != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          searching.value = false;
        } catch (_) {
          // El shell ya se liberó (se navegó fuera de la barra inferior).
        }
      });
    }
    super.dispose();
  }

  void _openTrack(String id) {
    final searching = ShellScope.of(context).searching;
    _searching = searching;
    searching.value = true;
    _timer?.cancel();
    _timer = Timer(AppDurations.searching, () {
      if (!mounted) return;
      context.go(Routes.track(id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: _HeaderDelegate()),
          BlocBuilder<ShipmentsBloc, ShipmentsState>(
            builder: (context, state) {
              final items = state.visible;
              if (items.isEmpty && state.status == ShipmentsStatus.success) {
                return SliverToBoxAdapter(child: _Empty(query: state.query));
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(22, 6, 22, 150),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder:
                      (context, i) => _ParcelItem(
                        parcel: items[i],
                        onTap: () => _openTrack(items[i].id),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 46, 22, 0),
      child: Text(
        'Ningún paquete coincide con “$query”.',
        textAlign: TextAlign.center,
        style: AppTypography.of(
          15,
          FontWeight.w400,
          color: AppColors.emptyText,
        ),
      ),
    );
  }
}

class _ParcelItem extends StatelessWidget {
  const _ParcelItem({required this.parcel, required this.onTap});

  final Parcel parcel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = ParcelStatusStyle.of(parcel.status);
    return ParcelCard(
      id: parcel.id,
      name: parcel.name,
      image: parcel.image,
      ribbonLabel: style.ribbonLabel,
      ribbonColor: style.ribbonColor,
      current: parcel.step,
      awayLabel: parcel.away,
      fromLabel: 'DE',
      toLabel: 'PARA',
      from: parcel.from,
      fromDate: Fmt.dateShort(parcel.sentOn),
      to: parcel.to,
      toDate: '${parcel.toDatePrefix} ${Fmt.dateShort(parcel.toDate)}',
      onTap: onTap,
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 266;

  @override
  double get maxExtent => 266;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate old) => false;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.shippingStickyGradient,
      ),
      padding: const EdgeInsets.only(top: 70, bottom: 12),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: ScreenTitleRow(
              title: 'Mis envíos',
              actionIcon: 'scan',
              actionLabel: 'Escanear',
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: _SearchField(),
          ),
          SizedBox(height: 16),
          _Chips(),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          const AppIcon('search', color: AppColors.searchIcon),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged:
                  (v) => context.read<ShipmentsBloc>().add(
                    ShipmentsQueryChanged(v),
                  ),
              cursorColor: AppColors.primary,
              style: AppTypography.body,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Busca tu paquete',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.searchText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentsBloc, ShipmentsState>(
      buildWhen: (a, b) => a.filter != b.filter || a.all != b.all,
      builder: (context, state) {
        return FilterChipBar(
          chips: [
            for (final f in ShipmentsFilter.values)
              FilterChipData(
                label: ParcelStatusStyle.filterLabel(f),
                count: state.countFor(f),
                selected: state.filter == f,
                onTap:
                    () => context.read<ShipmentsBloc>().add(
                      ShipmentsFilterChanged(f),
                    ),
              ),
          ],
        );
      },
    );
  }
}
