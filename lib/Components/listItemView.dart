import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/Components/EmptyCard.dart';
import 'package:unit_price/ItemsController.dart';
import 'package:unit_price/palette_controller.dart';

class ListItemView extends StatelessWidget {
  const ListItemView({
    super.key,
    required this.item,
    required this.onDismiss,
    this.onTap,
  });

  final ItemList item;
  final Function(ListItemView) onDismiss;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    var palette = PaletteController.palette;

    var textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Color(
            palette?.neutral.get(30) ??
                Theme.of(context).textTheme.headlineMedium?.color?.value ??
                0,
          ),
        );

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) => onDismiss(this),
      child: EmptyCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name ?? '',
              style: textStyle?.copyWith(
                fontWeight: FontWeight.bold,
                color: Color(palette?.neutral.get(20) ??
                    Theme.of(context).textTheme.headlineMedium?.color?.value ??
                    0),
              ),
            ),
            Text(
              "${item.items?.length} items",
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}
