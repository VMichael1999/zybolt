import 'package:flutter/material.dart';

/// Lista horizontal sin barra: padding lateral 22 y separación 12.
class HorizontalCards extends StatelessWidget {
  const HorizontalCards({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}
