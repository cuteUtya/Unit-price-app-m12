import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:unit_price/Components/ItemView.dart';
import 'package:unit_price/Components/NewListAlert.dart';
import 'package:unit_price/ItemsController.dart';
import 'package:unit_price/numberFormatter.dart';
import 'package:unit_price/palette_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
    required this.displayedList,
    required this.onCloseList,
    required this.onItemDelete,
    required this.controller,
    required this.removeAdditionPaddings,
  }) : super(key: key);

  final String? displayedList;
  final Function onCloseList;
  final Function(Function) onItemDelete;
  final ScreenshotController controller;
  final bool removeAdditionPaddings;

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? overrideName;
  @override
  Widget build(BuildContext context) {
    if (widget.displayedList == null) {
      return StreamBuilder(
        stream: ItemController.mainScreenItems,
        builder: (_, data) {
          if (data.data != null) {
            var items = data.data!;
            return _build(items);
          }

          return Container();
        },
      );
    }

    return StreamBuilder(
      stream: ItemController.lists,
      builder: (_, data) {
        if (data.data != null) {
          return _build(
            data.data!
                    .firstWhere(
                      (element) =>
                          element.name ==
                          (overrideName ?? widget.displayedList),
                    )
                    .items ??
                [],
          );
        }
        return Container();
      },
    );
  }

  Widget _build(List<Item> items) {
    var bestItem = findBestSell(items);
    var bestItemPrice = bestItem == null ? null : getPricePerKilogram(bestItem);

    return SingleChildScrollView(
      child: Screenshot(
        controller: widget.controller,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.displayedList != null)
                Stack(
                  fit: StackFit.loose,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          onPressed: () {
                            NewListAlert.show(
                              context,
                              isEdit: true,
                              onDone: (n) {
                                ItemController.currentList = n;
                                overrideName = n;
                                ItemController.renameList(
                                  oldName: widget.displayedList!,
                                  newName: n,
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              overrideName ?? widget.displayedList!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => widget.onCloseList(),
                      ),
                    )
                  ],
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 4,
                  ),
                  for (var i in items)
                    ItemView(
                      key: UniqueKey(),
                      item: i,
                      listName: overrideName ?? widget.displayedList,
                      onDismiss: (h) => setState(
                        () {
                          var index = items.indexOf(i);
                          widget.onItemDelete(
                            () => ItemController.addItem(
                              value: h.item,
                              list: widget.displayedList,
                              position: index,
                            ),
                          );
                          ItemController.removeItem(
                            value: h.item,
                            list: widget.displayedList,
                          );
                        },
                      ),
                      meta: ItemCalculationResult(
                        isBest: bestItem == null
                            ? false
                            : getPricePerKilogram(bestItem) >=
                                getPricePerKilogram(i),
                        pricePerKilogram: getPricePerKilogram(i),
                        percent: (getPricePerKilogram(i) / bestItemPrice! * 100)
                            .toInt(),
                      ),
                    ),
                  //whitespace in the bottom
                  SizedBox(
                    height: !widget.removeAdditionPaddings ? 100 : 8,
                  )
                ],
              ),
              //),
            ],
          ),
        ),
      ),
    );
  }



}
