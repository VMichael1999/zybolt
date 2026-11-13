import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';
import 'dotted_line.dart';

enum StepperNodeState { done, current, todo }

/// Nodo del stepper (Factory): decide si es hecho, actual o pendiente.
class StepperNode {
  const StepperNode(this.state);

  factory StepperNode.fromProgress(int index, int current) {
    if (index < current) return const StepperNode(StepperNodeState.done);
    if (index == current) return const StepperNode(StepperNodeState.current);
    return const StepperNode(StepperNodeState.todo);
  }

  final StepperNodeState state;
}

/// Texto bajo un nodo: nombre del paso y, si ya ocurrió, su hora.
class StepLabel {
  const StepLabel(this.name, [this.detail]);

  final String name;
  final String? detail;
}

/// 4 nodos unidos por conectores punteados.
/// `current` va de 0 a 3, o 4 cuando todo terminó.
class ShipmentStepper extends StatelessWidget {
  const ShipmentStepper({
    super.key,
    required this.current,
    this.awayLabel,
    this.labels,
  });

  final int current;
  final String? awayLabel;

  /// Un texto por nodo (4), mostrado debajo de cada uno.
  final List<StepLabel>? labels;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var k = 0; k < 4; k++) {
      if (k > 0) {
        children.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: DottedLine(
                color:
                    k <= current ? AppColors.primary : AppColors.stepLineTodo,
              ),
            ),
          ),
        );
      }
      children.add(
        _Node(
          StepperNode.fromProgress(k, current),
          awayLabel,
          label: labels?[k],
          align:
              k == 0
                  ? _LabelAlign.start
                  : (k == 3 ? _LabelAlign.end : _LabelAlign.center),
        ),
      );
    }
    return Row(children: children);
  }
}

enum _LabelAlign { start, center, end }

class _Node extends StatelessWidget {
  const _Node(this.node, this.awayLabel, {this.label, this.align});

  final StepperNode node;
  final String? awayLabel;
  final StepLabel? label;
  final _LabelAlign? align;

  @override
  Widget build(BuildContext context) {
    final core = _core();
    final l = label;
    if (l == null) return core;
    final current = node.state == StepperNodeState.current;
    final done = node.state == StepperNodeState.done;
    final nameColor =
        current ? AppColors.ink : (done ? AppColors.ink2 : AppColors.ink3);
    final alignment = align ?? _LabelAlign.center;
    final textAlign = switch (alignment) {
      _LabelAlign.start => TextAlign.left,
      _LabelAlign.end => TextAlign.right,
      _LabelAlign.center => TextAlign.center,
    };
    final cross = switch (alignment) {
      _LabelAlign.start => CrossAxisAlignment.start,
      _LabelAlign.end => CrossAxisAlignment.end,
      _LabelAlign.center => CrossAxisAlignment.center,
    };
    // La fila mide 32; los nodos de 22 quedan centrados (5 px de margen).
    final top = current ? 32.0 + 6 : 22.0 + 6 + 5;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        core,
        Positioned(
          top: top,
          left: switch (alignment) {
            _LabelAlign.start => 0,
            _LabelAlign.end => null,
            _LabelAlign.center => -40,
          },
          right: switch (alignment) {
            _LabelAlign.start => null,
            _LabelAlign.end => 0,
            _LabelAlign.center => -40,
          },
          width: alignment == _LabelAlign.center ? null : 110,
          child: Column(
            crossAxisAlignment: cross,
            children: [
              Text(
                l.name,
                softWrap: false,
                textAlign: textAlign,
                style: AppTypography.of(
                  11.5,
                  FontWeight.w600,
                  color: nameColor,
                ),
              ),
              if (l.detail != null)
                Text(
                  l.detail!,
                  softWrap: false,
                  textAlign: textAlign,
                  style: AppTypography.of(
                    11,
                    FontWeight.w500,
                    color: current ? AppColors.primary : AppColors.ink3,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _core() {
    switch (node.state) {
      case StepperNodeState.done:
        return Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const AppIcon(
            'check',
            size: 12,
            color: AppColors.white,
            strokeWidth: 3,
          ),
        );
      case StepperNodeState.todo:
        return Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.stepTodo, width: 1.5),
          ),
          child: const AppIcon(
            'check',
            size: 11,
            color: AppColors.stepTodo,
            strokeWidth: 2.6,
          ),
        );
      case StepperNodeState.current:
        return SizedBox(
          width: 32,
          height: 32,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const AppIcon(
                  'truck',
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              if (awayLabel != null && awayLabel!.isNotEmpty)
                Positioned(
                  left: -100,
                  right: -100,
                  bottom: 37,
                  child: Text(
                    awayLabel!,
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: AppTypography.of(12, FontWeight.w700),
                  ),
                ),
            ],
          ),
        );
    }
  }
}
