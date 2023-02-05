import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamic_color/samples.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unit_price/Components/NewObjectScreen.dart';
import 'package:unit_price/Components/Screens/MainScreen.dart';
import 'package:unit_price/Icons/spectrum_icons_icons.dart';
import 'package:unit_price/ItemsController.dart';
import 'package:unit_price/ThemeController.dart';
import 'package:unit_price/numberFormatter.dart';
import 'package:unit_price/palette_controller.dart';

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
    return App();
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        var brightness = SchedulerBinding.instance.window.platformBrightness;
        bool isDarkMode = brightness == Brightness.dark;

        useDarkTheme = isDarkMode;

        var color = useDarkTheme ? darkColorScheme : lightColorScheme;

        var seedColor = const Color(0xff3279a8);
        color ??= ColorScheme.fromSeed(seedColor: seedColor, brightness: useDarkTheme ? Brightness.dark : Brightness.light,);
        if(lightColorScheme == null) PaletteController.set(color.primary.value);

        return MaterialApp(
          title: 'Unit price',
          theme: ThemeData(
            colorScheme: color,
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance?.window.onPlatformBrightnessChanged = () {
      setState(() {});
    };
    super.initState();
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

  GlobalKey buttonKey = GlobalKey();

  Widget buildUndoButton(bool transparent) {
    return !transparent
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FloatingActionButton.small(
              onPressed: () {
                undoDeletingStack.last.call();
                setState(() => undoDeletingStack.removeLast());
              },
              child: const Icon(Icons.undo),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var topBarHeight = 52.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness:
            useDarkTheme ? Brightness.light : Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
      ),
      child: Scaffold(
        floatingActionButton: Opacity(
          opacity: 0.8,
          child: Stack(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  buildUndoButton(undoDeletingStack.isNotEmpty),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: ItemController.mainScreenItems,
                        builder: (_, d) => (d.data?.isEmpty ?? true)
                            ? SizedBox()
                            : FloatingActionButton.small(
                                onPressed: () {
                                  List<Item> copy =
                                      ItemController.mainScreenValue.toList();
                                  ItemController.deleteList();
                                  onItemDelete(
                                    () => ItemController.addItems(items: copy),
                                  );
                                },
                                child: const Icon(Icons.delete_outline),
                              ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      FloatingActionButton(
                        onPressed: () => NewObjectScreen.show(context),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        body: ColoredBox(
          color: Theme.of(context).colorScheme.background,
          child: Stack(
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
                height: topBarHeight + MediaQuery.of(context).padding.top,
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
                top: 0 + MediaQuery.of(context).padding.top,
                left: 0,
                right: 14,
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

                        var screenshot = await contentScreenshot.capture();
                        Directory tempDir = await getTemporaryDirectory();
                        String tempPath = '${tempDir.path}/screen.jpeg';

                        var file =
                            await File(tempPath).writeAsBytes(screenshot!);
                        await Share.shareXFiles([XFile(file.path)]);
                      },
                      icon: Icon(
                        SpectrumIcons.export_image,
                        color: useDarkTheme
                            ? Colors.white
                            : Theme.of(context)
                                .appBarTheme
                                .titleTextStyle
                                ?.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Share.share(
                          formatList(
                            ItemController.mainScreenValue,
                            findBestSell(ItemController.mainScreenValue)!,
                          ),
                        );
                      },
                      icon: Icon(
                        SpectrumIcons.export_textv1,
                        color: useDarkTheme
                            ? Colors.white
                            : Theme.of(context)
                                .appBarTheme
                                .titleTextStyle
                                ?.color,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String formatList(List<Item> items, Item bestSale) {
    String result = '';

    int m(int d) => d < 0 ? 0 : d;

    var bestKgPrice = getPricePerKilogram(bestSale);

    String getStatus(Item i) {
      var pPerK = getPricePerKilogram(i);
      bool isBest = bestKgPrice >= pPerK;
      var fColumn = isBest
          ? "👍"
          : "+${(formatNumber(pPerK / bestKgPrice * 100 - 100))}%";
      fColumn = "[$fColumn]";
      return fColumn;
    }

    String space(int count) {
      return List.filled(count, ' ').join();
    }

    var biggestStatus = items.map((e) => getStatus(e).length).reduce(max) + 1;

    for (var i in items) {
      var pPerK = getPricePerKilogram(i);

      String newLine = '';
      var status = getStatus(i);
      status += space(
          biggestStatus - status.length - (status.contains('👍') ? 1 : 0));
      newLine += status;
      newLine += 'Цена/кг${space(2)}';
      newLine += formatNumber(pPerK);
      newLine += "\n";
      newLine += " ".padRight(biggestStatus);
      newLine += "Вес${space(6)}";
      newLine += formatNumber(i.weight!);
      newLine += "\n";
      newLine += "".padRight(biggestStatus);
      newLine += "Цена${space(5)}";
      newLine += formatNumber(i.price!);
      newLine += "\n";
      newLine += items.indexOf(i) + 1 == items.length ? '' : "\n";

      result += newLine;
    }

    return "```$result```";
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
