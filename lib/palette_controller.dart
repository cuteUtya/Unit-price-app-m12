import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class PaletteController {
  static late CorePalette palette;

  static load() async {
    var v = await DynamicColorPlugin.getCorePalette();;
    if(v != null) palette = v!;
  }

  static set(int colorSeed) {
      palette = CorePalette.of(colorSeed);
  }
}
