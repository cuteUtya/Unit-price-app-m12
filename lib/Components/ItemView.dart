import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/ItemsController.dart';

class ItemView extends StatelessWidget {
  const ItemView({
    required this.key,
    required this.item,
  }) : super(key: key);

  final Item item;
  final Key key;

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
            var fontStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isHeadline
                      ? null
                      : Theme.of(context).textTheme.headlineMedium?.color,
                  fontWeight: isHeadline ? FontWeight.bold : null,
                );

            var textBackColor = Color(palette?.primary.get(70) ??
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
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: !isHeadline ? null : BoxDecoration(
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

          var cardColor = Color(palette?.primary?.get(95) ??
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
                    badge: "100%",
                    value:
                        ((1000 / item.weight) * item.price).toStringAsFixed(2),
                  ),
                  buildLine(
                    icon: Icons.ac_unit_rounded,
                    name: "Вес",
                    isHeadline: false,
                    value: item.weight.toStringAsFixed(2),
                  ),
                  buildLine(
                    icon: Icons.price_change_rounded,
                    name: "Цена",
                    isHeadline: false,
                    value: item.price.toStringAsFixed(2),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
