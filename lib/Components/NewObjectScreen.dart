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
      {bool isEdit = false,
      Function(double, double)? onComplete,
      double? weight,
      double? price}) {
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
  late final TextEditingController _widthEnterController =
      TextEditingController(
          text: widget.weight == null ? null : formatNumber(widget.weight!));
  late final TextEditingController _priceEnterController =
      TextEditingController(
          text: widget.price == null ? null : formatNumber(widget.price!));
  final FocusNode priceFocus = FocusNode();
  final FocusNode weighFocus = FocusNode();

  bool weightError = false;
  bool priceError = false;
  bool isUniqueError = false;

  void clearError() {
    weightError = false;
    priceError = false;
    setState(() => {});
  }

  void delayClearError() {
    Future.delayed(const Duration(seconds: 1), () => clearError());
  }

  void addValue(BuildContext context) {
    var weight = double.tryParse(_widthEnterController.value.text);
    var price = double.tryParse(_priceEnterController.value.text);

    if (!ItemController.checkItemUnique(Item(weight: weight, price: price))) {
      weightError = true;
      priceError = true;
      isUniqueError = true;
      setState(() {
        FocusScope.of(context).requestFocus(priceFocus);
        delayClearError();
      });
      return;
    }

    if (price != null && weight != null && weight > 0 && price > 0) {
      if (!widget.isEdit) {
        ItemController.addItem(
          value: Item(weight: weight, price: price),
          list: ItemController.currentList,
        );
      } else {
        if (widget.onComplete != null) {
          widget.onComplete!(weight, price);
        }
      }
      Navigator.of(context).pop();
    } else {
      if (weight == null || weight <= 0) weightError = true;
      if (price == null || price <= 0) priceError = true;
      isUniqueError = false;
      setState(() {
        if (weightError) {
          FocusScope.of(context).requestFocus(weighFocus);
        } else {
          FocusScope.of(context).requestFocus(priceFocus);
        }
        delayClearError();
      });
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
                          focusNode: weighFocus,
                          onSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(priceFocus),
                          decoration: InputDecoration(
                            labelText: 'Вес',
                            border: const OutlineInputBorder(),
                            errorText: weightError
                                ? (isUniqueError ? '' : 'Ошибка ввода')
                                : null,
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
                            labelText: 'Цена',
                            border: const OutlineInputBorder(),
                            errorText: priceError
                                ? (isUniqueError
                                    ? 'Уже в списке'
                                    : 'Ошибка ввода')
                                : null,
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
