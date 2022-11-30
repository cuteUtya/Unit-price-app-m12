import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/Components/listItemView.dart';
import 'package:unit_price/ItemsController.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.onCategoryOpen,
  });

  final Function(String) onCategoryOpen;

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
                  onDismiss: (i) => ItemController.deleteList(
                    list: i.item.name,
                  ),
                ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
