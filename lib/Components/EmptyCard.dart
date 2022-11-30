import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/palette_controller.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    super.key,
    required this.child,
    this.cardColor,
  });

  final Widget child;
  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    var palette = PaletteController.palette;
    var color = cardColor ??
        Color(palette?.primary?.get(95) ??
            Theme.of(context).colorScheme.surfaceVariant.value);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: child,
    );
  }
}
