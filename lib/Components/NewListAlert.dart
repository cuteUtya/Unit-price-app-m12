import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unit_price/ItemsController.dart';

class NewListAlert extends StatefulWidget {
  const NewListAlert({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const NewListAlert();
      },
    );
  }

  @override
  State<StatefulWidget> createState() => NewListAlertState();
}

class NewListAlertState extends State<NewListAlert> {

  TextEditingController controller = TextEditingController();
  bool enterInvalid = false;

  void add() {
    var val = controller.value.text;

    if(val.isEmpty) {
      setState(() => enterInvalid = true);
    } else {
      ItemController.addList(name: val);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New list'),
      content: SingleChildScrollView(
        child: ListBody(
          children:  <Widget>[
            TextField(
              autofocus: true,
              onTap: () => setState(() => enterInvalid = false),
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: enterInvalid ? 'Name can\'t be empty' : null,
                border: const OutlineInputBorder(),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            add();
          },
        ),
      ],
    );
  }
}
