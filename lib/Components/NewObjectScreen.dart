import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unit_price/ItemsController.dart';
import 'package:unit_price/numberFormatter.dart';

class NewObjectScreen extends StatefulWidget {
  const NewObjectScreen({
    Key? key,
    this.onComplete,
    this.isEdit = false,
    this.price,
    this.weight,
  }) : super(key: key);

  final Function(double, double)? onComplete;
  final bool isEdit;
  final double? weight;
  final double? price;

  static void show(BuildContext context,
      {bool isEdit = false, Function(double, double)? onComplete, double? weight, double? price}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return NewObjectScreen(
          isEdit: isEdit,
          onComplete: onComplete,
          weight: weight,
          price: price,
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _NewObjectScreenState();
}

class _NewObjectScreenState extends State<NewObjectScreen> {
   late final TextEditingController _widthEnterController = TextEditingController(text: widget.weight == null ? null : formatNumber(widget.weight!));
   late final TextEditingController _priceEnterController = TextEditingController(text: widget.price == null ? null : formatNumber(widget.price!));
  final FocusNode priceFocus = FocusNode();

  bool weightError = false;
  bool priceError = false;

  void clearError() {
    weightError = false;
    priceError = false;
    setState(() => {});
  }

  void addValue(BuildContext context) {
    var weight = double.tryParse(_widthEnterController.value.text);
    var price = double.tryParse(_priceEnterController.value.text);

    if (price != null && weight != null && weight > 0 && price > 0) {
      if(!widget.isEdit) {
        ItemController.addItem(
          value: Item(weight: weight, price: price),
          list: ItemController.currentList,
        );
      } else {
        if(widget.onComplete != null) {
          widget.onComplete!(weight, price);
        }
      }
      Navigator.of(context).pop();
    } else {
      if (weight == null || weight <= 0) weightError = true;
      if (price == null || price <= 0) priceError = true;
      setState(() => {});
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
                          onTap: () => clearError(),
                          controller: _widthEnterController,
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(priceFocus),
                          decoration: InputDecoration(
                            labelText: 'Weigh',
                            border: const OutlineInputBorder(),
                            errorText: weightError ? 'invalid' : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: inputWidth,
                        child: TextField(
                          controller: _priceEnterController,
                          keyboardType: TextInputType.number,
                          onTap: () => clearError(),
                          focusNode: priceFocus,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: const OutlineInputBorder(),
                            errorText: priceError ? 'invalid' : null,
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
