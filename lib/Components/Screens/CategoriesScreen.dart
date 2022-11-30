import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/Components/listItemView.dart';
import 'package:unit_price/ItemsController.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.onCategoryOpen,
    required this.onListDelete,
  });

  final Function(String) onCategoryOpen;
  final Function(Function) onListDelete;

  @override
  State<StatefulWidget> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ItemController.lists,
      builder: (_, data) {
        var lists = data.data;

        if (lists != null) {
          return ListView(
            children: [
              for (var l in lists)
                ListItemView(
                  onTap: (item) => widget.onCategoryOpen(item.item.name!),
                  item: l,
                  onDismiss: (i) {
                    var index = lists.indexOf(i.item);
                    widget.onListDelete(() {
                      ItemController.addList(
                        name: i.item.name ?? 'Name',
                        items: i.item.items,
                        position: index,
                      );
                    });
                    ItemController.deleteList(
                      list: i.item.name,
                    );
                  },
                ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
