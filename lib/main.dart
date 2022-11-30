import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unit_price/Components/NewListAlert.dart';
import 'package:unit_price/Components/NewObjectScreen.dart';
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
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );

    const duration = Duration(milliseconds: 250);
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: duration,
        opacity: currentPageIndex != 0 ? 0 : 1,
        child: AnimatedContainer(
          duration: duration,
          transform: Matrix4.translation(
            vector.Vector3(
              currentPageIndex != 0 ? 100 : 0,
              0,
              0,
            ),
          ),
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FloatingActionButton.small(
                onPressed: () => NewListAlert.show(context),
                child: const Icon(Icons.playlist_add),
              ),
              const SizedBox(height: 6),
              FloatingActionButton(
                onPressed: () => NewObjectScreen.show(context),
                child: const Icon(Icons.add),
                //icon: Icons.add,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => setState(
          () => currentPageIndex = index,
        ),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: ColoredBox(
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: <Widget>[
            const MainScreen(),
            Container(
              alignment: Alignment.center,
              child: const Text('Page 2'),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text('Page 3'),
            ),
          ][currentPageIndex],
        ),
      ),
    );
  }
}
