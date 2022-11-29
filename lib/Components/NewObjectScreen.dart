import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewObjectScreen extends StatelessWidget {
  const NewObjectScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const NewObjectScreen();
      },
    );
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
                      horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: inputWidth,
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Weigh',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: inputWidth,
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Weigh',
                            border: OutlineInputBorder(),
                          ),
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
