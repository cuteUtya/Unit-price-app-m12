import 'package:unit_price/ItemsController.dart';

String formatNumber(double value) {
  return value.toStringAsFixed(2).replaceAll('.00', '').replaceAll(',00', '');
}

double getPricePerKilogram(Item item) {
  return ((1000 / item.weight!) * item.price!);
}


Item? findBestSell(List<Item> items) {
  if (items.isEmpty) return null;

  Item best = items.first;

  for (var item in items) {
    if (getPricePerKilogram(item) < getPricePerKilogram(best)) {
      best = item;
    }
  }

  return best;
}