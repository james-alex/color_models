import 'package:color_models/color_models.dart' show ColorModel;

mixin RgbGetters on ColorModel {
  /// The red value of this color.
  int get red => toRgbColor().red;

  /// The green value of this color.
  int get green => toRgbColor().green;

  /// The blue value of this color.
  int get blue => toRgbColor().blue;

  double get a => alpha / 255.0;

  double get r => toRgbColor().red / 255.0;

  double get g => toRgbColor().green / 255.0;

  double get b => toRgbColor().blue / 255.0;
}
