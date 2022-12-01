import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/Components/EmptyCard.dart';
import 'package:unit_price/Components/NewObjectScreen.dart';
import 'package:unit_price/Icons/spectrum_icons_icons.dart';
import 'package:unit_price/ItemsController.dart';
import 'package:unit_price/ThemeController.dart';
import 'package:unit_price/numberFormatter.dart';
import 'package:unit_price/palette_controller.dart';

class ItemView extends StatelessWidget {
  const ItemView({
    required this.key,
    required this.item,
    required this.listName,
    required this.meta,
    required this.onDismiss,
  }) : super(key: key);

  final Item item;
  final String? listName;
  final Key key;
  final ItemCalculationResult meta;
  final Function(ItemView) onDismiss;

  @override
  Widget build(BuildContext context) {
    var palette = PaletteController.palette;

    Widget buildLine({
      required IconData icon,
      required String name,
      required bool isHeadline,
      String? badge,
      required String value,
    }) {
      var headColor = meta.isBest
          ? Color(palette?.primary.get(getToneOfColor(20) ?? 0))
          : Color(palette?.neutral.get(getToneOfColor(20)) ??
              Theme.of(context).textTheme.headlineMedium?.color?.value ??
              0);
      var secondaryColor = meta.isBest
          ? Color(palette?.primary.get(getToneOfColor(30 ?? 0)))
          : Color(palette?.neutral.get(getToneOfColor(30)) ??
              Theme.of(context).textTheme.headlineMedium?.color?.value ??
              0);

      var fontStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isHeadline ? headColor : secondaryColor,
            fontWeight: isHeadline ? FontWeight.bold : null,
          );

      var textBackColor = Color(palette?.primary.get(getToneOfColor(meta.isBest ? 70 : 90)) ??
          Theme.of(context).colorScheme.primary.value);

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    icon,
                    color: fontStyle?.color,
                    size: (fontStyle?.fontSize ?? 10) * 1.25,
                  ),
                ),
                Text(
                  name,
                  style: fontStyle,
                ),
                if (badge != null && !meta.isBest)
                  Transform.translate(
                      offset: const Offset(2, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(palette?.tertiary.get(50) ?? 0),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(palette?.tertiary.get(getToneOfColor(100)) ?? 0),
                          ),
                        ),
                      ))
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: !isHeadline
                  ? null
                  : BoxDecoration(
                      color: textBackColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
              child: Text(
                value,
                style: fontStyle,
              ),
            ),
          ],
        ),
      );
    }

    var cardColor = Color(palette?.primary?.get(getToneOfColor(meta.isBest ? 80 : 95)) ??
        Theme.of(context).colorScheme.surfaceVariant.value);

    return Dismissible(
      key: key,
      onDismissed: (_) => onDismiss(this),
      child: EmptyCard(
        cardColor: cardColor,
        onTap: () => NewObjectScreen.show(
          context,
          onComplete: (d1, d2) => {
            ItemController.replaceItem(oldItem: item, newItem: Item(weight: d1, price: d2), list: listName,)
          },
          weight: item.weight,
          price: item.price,
          isEdit: true,
        ),
        child: Column(
          children: [
            buildLine(
              icon: SpectrumIcons.weight_kilogram,
              name: "Цена за кг",
              isHeadline: true,
              badge: "${meta.percent - 100}%",
              value: formatNumber(meta.pricePerKilogram),
            ),
            buildLine(
              icon: SpectrumIcons.scale,
              name: "Вес",
              isHeadline: false,
              value: formatNumber(item.weight!),
            ),
            buildLine(
              icon: Icons.price_change_rounded,
              name: "Цена",
              isHeadline: false,
              value: formatNumber(item.price!),
            ),
          ],
        ),
      ),
    );
  }


}

class ItemCalculationResult {
  const ItemCalculationResult({
    required this.isBest,
    required this.percent,
    required this.pricePerKilogram,
  });
  final int percent;
  final bool isBest;
  final double pricePerKilogram;
}
