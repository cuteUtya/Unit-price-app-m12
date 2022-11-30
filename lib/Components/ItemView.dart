import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/ItemsController.dart';

class ItemView extends StatelessWidget {
  const ItemView({
    required this.key,
    required this.item,
    required this.meta,
  }) : super(key: key);

  final Item item;
  final Key key;
  final ItemCalculationResult meta;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DynamicColorPlugin.getCorePalette(),
      builder: (_, paletteData) {
        var palette = paletteData.data;

        Widget buildLine({
          required IconData icon,
          required String name,
          required bool isHeadline,
          String? badge,
          required String value,
        }) {
          var headColor = meta.isBest
              ? Color(palette?.primary.get(20) ?? 0)
              : Color(palette?.neutral.get(20) ??
                  Theme.of(context).textTheme.headlineMedium?.color?.value ??
                  0);
          var secondaryColor = meta.isBest
              ? Color(palette?.primary.get(30) ?? 0)
              : Color(palette?.neutral.get(30) ??
                  Theme.of(context).textTheme.headlineMedium?.color?.value ??
                  0);

          var fontStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isHeadline ? headColor : secondaryColor,
                fontWeight: isHeadline ? FontWeight.bold : null,
              );

          var textBackColor = Color(palette?.primary.get(meta.isBest ? 70 : 90) ??
              Theme.of(context).colorScheme.primary.value);

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: fontStyle?.color,
                      size: (fontStyle?.fontSize ?? 10) * 1.25,
                    ),
                    Text(
                      name,
                      style: fontStyle,
                    ),
                    if (badge != null && !meta.isBest)
                      Transform.translate(
                        offset: const Offset(0, -5),
                        child: Text(
                          badge!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(palette?.tertiary.get(40) ?? 0),
                          ),
                        ),
                      )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: !isHeadline
                      ? null
                      : BoxDecoration(
                          color: textBackColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                  child: Text(
                    value,
                    style: fontStyle,
                  ),
                )
              ],
            ),
          );
        }

        var cardColor = Color(palette?.primary?.get(meta.isBest ? 80 : 95) ??
            Theme.of(context).colorScheme.surfaceVariant.value);

        return Dismissible(
          key: key,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                buildLine(
                  icon: Icons.add_alert_rounded,
                  name: "Цена за кг",
                  isHeadline: true,
                  badge: "${meta.percent}%",
                  value: ((1000 / item.weight!) * item.price!).toStringAsFixed(2),
                ),
                buildLine(
                  icon: Icons.ac_unit_rounded,
                  name: "Вес",
                  isHeadline: false,
                  value: item.weight!.toStringAsFixed(2),
                ),
                buildLine(
                  icon: Icons.price_change_rounded,
                  name: "Цена",
                  isHeadline: false,
                  value: item.price!.toStringAsFixed(2),
                ),
              ],
            ),
          ),
        );
      },
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
