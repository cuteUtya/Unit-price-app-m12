import 'package:dynamic_color/dynamic_color.dart';

class PaletteController {
  static dynamic palette;

  static load() async {
    palette = await DynamicColorPlugin.getCorePalette();
  }
}
