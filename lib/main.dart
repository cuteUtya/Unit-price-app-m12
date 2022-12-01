import 'dart:io';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unit_price/Components/NewListAlert.dart';
import 'package:unit_price/Components/NewObjectScreen.dart';
import 'package:unit_price/Components/Screens/CategoriesScreen.dart';
import 'package:unit_price/Components/Screens/MainScreen.dart';
import 'package:unit_price/ItemsController.dart';
import 'package:unit_price/ThemeController.dart';
import 'package:unit_price/palette_controller.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ItemController.load();
  await PaletteController.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: useDarkTheme ? darkColorScheme : lightColorScheme,
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String? openedCategoryName;
  List<Function> undoDeletingStack = [];
  ScreenshotController contentScreenshot = ScreenshotController();

  Widget buildUndoButton(bool transparent) {
    return AnimatedOpacity(
      opacity: transparent ? 1 : 0,
      duration: const Duration(milliseconds: 250),
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: FloatingActionButton.small(
          onPressed: () {
            undoDeletingStack.last.call();
            setState(() => undoDeletingStack.removeLast());
          },
          child: const Icon(Icons.undo),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var topBarHeight = 52.0;

    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              buildUndoButton(undoDeletingStack.isNotEmpty),
              Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: FloatingActionButton(
                      onPressed: () => NewObjectScreen.show(context),
                      child: const Icon(Icons.add),
                      //icon: Icons.add,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 52,
              ),
              MainScreen(
                controller: contentScreenshot,
                removeAdditionPaddings: true,
                displayedList: ItemController.currentList,
                onCloseList: () => setState(
                  () => ItemController.currentList = null,
                ),
                onItemDelete: onItemDelete,
              ),
            ],
          ),
          SizedBox(
            height: topBarHeight,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Colors.transparent.withOpacity(0.1),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    var status = await Permission.storage.status;
                    if (status.isDenied) {
                      await Permission.storage.request();
                    }

                    var screenshot = await contentScreenshot
                        .capture(); /*captureFromWidget(
                      Container(
                        height: double.infinity,
                        color: Theme.of(context).colorScheme.background,
                        child: MediaQuery(
                          data: MediaQuery.of(context),
                          child: mainScreen(true),
                        ),
                      ),
                      delay: const Duration(milliseconds: 50),
                    );*/
                    Directory tempDir = await getTemporaryDirectory();
                    String tempPath = '${tempDir.path}/screen.jpeg';

                    var file = await File(tempPath).writeAsBytes(screenshot!);
                    Share.shareXFiles([XFile(file.path)]);

                    //TODO
                  },
                  icon: Icon(
                    Icons.image,
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.text_fields,
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.download,
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onItemDelete(Function prevent) {
    setState(() => undoDeletingStack.add(prevent));
    Future.delayed(
      const Duration(seconds: 3),
      () => setState(
        () => undoDeletingStack.remove(prevent),
      ),
    );
  }
}
