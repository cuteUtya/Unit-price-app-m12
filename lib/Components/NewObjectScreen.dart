import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/ItemsController.dart';

class NewObjectScreen extends StatelessWidget {
  NewObjectScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return NewObjectScreen();
      },
    );
  }

  final TextEditingController _widthEnterController = TextEditingController();
  final TextEditingController _priceEnterController = TextEditingController();

  void addValue(BuildContext context) {
    var weight = double.tryParse(_widthEnterController.value.text);
    var price = double.tryParse(_priceEnterController.value.text);

    if (price != null && weight != null) {
      ItemController.addItem(
        value: Item(weight: weight, price: price),
      );
      Navigator.of(context).pop();
    } else {
      //TODO force exception in inputs
    }
  }

  @override
  Widget build(BuildContext context) {
    var horizontalPadding = 18.0;
    var verticalPadding = 24.0;
    var inputWidth =
        MediaQuery.of(context).size.width * 0.5 - horizontalPadding - 8;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.background,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: inputWidth,
                        child: TextField(
                          autofocus: true,
                          controller: _widthEnterController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weigh',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: inputWidth,
                        child: TextField(
                          controller: _priceEnterController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => addValue(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
