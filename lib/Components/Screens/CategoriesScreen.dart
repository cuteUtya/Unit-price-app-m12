import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/Components/EmptyCard.dart';
import 'package:unit_price/Components/listItemView.dart';
import 'package:unit_price/ItemsController.dart';
import 'package:unit_price/palette_controller.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

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
                  onTap: () => print('bebra'),
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
