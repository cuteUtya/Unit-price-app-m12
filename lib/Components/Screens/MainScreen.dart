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
    return StreamBuilder(
      stream: ItemController.mainScreenItems,
      builder: (_, data) {
        if (data.data != null) {
          var items = data.data!;

          return ListView(
            children: [
              for (var i in items)
                ItemView(
                  key: Key(items.indexOf(i).toString()),
                  item: i,
                )
            ],
          );
        }

        return Container();
      },
    );
  }
}
