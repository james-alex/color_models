import 'package:color_models/color_models.dart' as cm show ColorModel;
import 'package:flutter/painting.dart' show Color;
import 'package:meta/meta.dart';
import 'models/cmyk_color.dart';
import 'models/hsb_color.dart';
import 'models/hsi_color.dart';
import 'models/hsl_color.dart';
import 'models/hsp_color.dart';
import 'models/lab_color.dart';
import 'models/rgb_color.dart';
import 'models/xyz_color.dart';

export 'models/cmyk_color.dart';
export 'models/hsb_color.dart';
export 'models/hsi_color.dart';
export 'models/hsl_color.dart';
export 'models/hsp_color.dart';
export 'models/lab_color.dart';
export 'models/rgb_color.dart';
export 'models/xyz_color.dart';

@immutable
abstract class ColorModel implements cm.ColorModel, Color {
  /// Returns `this` as a [Color], converting the model to RGB if necessary.
  Color toColor();

  @override
  ColorModel withAlpha(int alpha);

  @override
  ColorModel withOpacity(double opacity);
}

extension ToColorModel on Color {
  /// Returns this color as a [CmykColor].
  CmykColor toCmykColor() => CmykColor.fromColor(this);

  /// Returns this color as a [HsbColor].
  HsbColor toHsbColor() => HsbColor.fromColor(this);

  /// Returns this color as a [HsiColor].
  HsiColor toHsiColor() => HsiColor.fromColor(this);

  /// Returns this color as a [HslColor].
  HslColor toHslColor() => HslColor.fromColor(this);

  /// Returns this color as a [HspColor].
  HspColor toHspColor() => HspColor.fromColor(this);

  /// Returns this color as a [LabColor].
  LabColor toLabColor() => LabColor.fromColor(this);

  /// Returns this color as a [RgbColor].
  RgbColor toRgbColor() => RgbColor.fromColor(this);

  /// Returns this color as a [XyzColor].
  XyzColor toXyzColor() => XyzColor.fromColor(this);
}
