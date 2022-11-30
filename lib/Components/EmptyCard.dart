import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/palette_controller.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    super.key,
    required this.child,
    this.cardColor,
    this.onTap,
  });

  final Widget child;
  final Color? cardColor;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    var palette = PaletteController.palette;
    var color = cardColor ??
        Color(palette?.primary?.get(95) ??
            Theme.of(context).colorScheme.surfaceVariant.value);

    var radius = const BorderRadius.all(
      Radius.circular(10),
    );

    Widget child = this.child;

    if (onTap != null) {
      child = MaterialButton(
        onPressed: () => onTap?.call(),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 12 - (onTap == null ? 0 : 8), vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: child),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
      ),
      padding: onTap != null
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Material(
        color: color,
        clipBehavior: Clip.antiAlias, // Add This
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: child,
      ),
    );
  }
}
