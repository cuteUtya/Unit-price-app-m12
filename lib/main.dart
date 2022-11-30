import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unit_price/Components/NewListAlert.dart';
import 'package:unit_price/Components/NewObjectScreen.dart';
import 'package:unit_price/Components/Screens/CategoriesScreen.dart';
import 'package:unit_price/Components/Screens/MainScreen.dart';
import 'package:unit_price/ItemsController.dart';
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
            colorScheme: lightColorScheme,
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
  int currentPageIndex = 2;
  String? openedCategoryName;
  List<Function> undoDeletingStack = [];

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
    const duration = Duration(milliseconds: 250);

    return Scaffold(
      floatingActionButton: Stack(
        children: [
          AnimatedOpacity(
            duration: duration,
            opacity: currentPageIndex != 2 ? 0 : 1,
            child: AnimatedContainer(
              duration: duration,
              transform: Matrix4.translation(
                vector.Vector3(
                  currentPageIndex != 2 ? 100 : 0,
                  0,
                  0,
                ),
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  buildUndoButton(undoDeletingStack.isNotEmpty),
                  Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: ItemController.currentList == null ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: FloatingActionButton.small(
                          onPressed: () => NewListAlert.show(context),
                          child: const Icon(Icons.playlist_add),
                        ),
                      ),
                      const SizedBox(height: 6),
                      FloatingActionButton(
                        onPressed: () => NewObjectScreen.show(context),
                        child: const Icon(Icons.add),
                        //icon: Icons.add,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: currentPageIndex == 1 && undoDeletingStack.isNotEmpty ? buildUndoButton(
              true,
            ) : Container(),
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => setState(
          () => currentPageIndex = index,
        ),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
      ),
      body: ColoredBox(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Text('Page 3'),
            ),
            CategoriesScreen(
              onListDelete: (i) => onItemDelete(i),
              onCategoryOpen: (name) => {
                setState(
                  () {
                    currentPageIndex = 2;
                    ItemController.currentList = name;
                  },
                )
              },
            ),
            MainScreen(
              displayedList: ItemController.currentList,
              onCloseList: () => setState(
                () => ItemController.currentList = null,
              ),
              onItemDelete: onItemDelete,
            ),
          ][currentPageIndex],
        ),
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
