import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unit_price/ItemsController.dart';

class NewListAlert extends StatefulWidget {
  const NewListAlert({
    super.key,
    this.onDone,
    this.isEdit = false,
  });

  final Function(String)? onDone;
  final bool isEdit;

  static void show(BuildContext context,
      {bool? isEdit, Function(String)? onDone}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NewListAlert(
          onDone: onDone,
          isEdit: isEdit ?? false,
        );
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

    if (val.isEmpty) {
      setState(() => enterInvalid = true);
    } else {
      if(widget.onDone != null) {
        widget.onDone!(val);
      }
      if(!widget.isEdit) {
        ItemController.addList(name: val);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ?  'Rename' : 'New list'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              autofocus: true,
              onTap: () => setState(() => enterInvalid = false),
              controller: controller,
              decoration: InputDecoration(
                labelText: widget.isEdit ? 'New name' : 'Name',
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
          child: Text(widget.isEdit ? 'Edit' : 'Add'),
          onPressed: () {
            add();
          },
        ),
      ],
    );
  }
}
