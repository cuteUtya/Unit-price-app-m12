import 'package:flutter/cupertino.dart';
import 'package:unit_price/Components/ItemView.dart';
import 'package:unit_price/ItemsController.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    int updateIteration = 0;
    return StreamBuilder(
      stream: ItemController.mainScreenItems,
      builder: (_, data) {
        updateIteration++;
        if (data.data != null) {
          var items = data.data!;
          var bestItem = findBestSell(items);
          var bestItemPrice =
              bestItem == null ? null : getPricePerKilogram(bestItem);

          return ListView(
            children: [
              for (var i in items)
                ItemView(
                  key:
                      UniqueKey(), //Key('$updateIteration + ${items.indexOf(i).toString()}'),
                  item: i,
                  onDismiss: (h) => setState(
                    () {
                      updateIteration++;
                      ItemController.removeItem(value: h.item);
                    },
                  ),
                  meta: ItemCalculationResult(
                    isBest: bestItem == i,
                    pricePerKilogram: getPricePerKilogram(i),
                    percent:
                        (getPricePerKilogram(i) / bestItemPrice! * 100).toInt(),
                  ),
                )
            ],
          );
        }

        return Container();
      },
    );
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
}
