import 'package:flutter/material.dart' show Color;
import '../../../color_model.dart' as cm;
import '../../../flutter_color_model.dart';

mixin ToColor on ColorModel {
  @override
  bool equals(ColorModel color) {
    assert(color != null);

    return RgbColor.from(this) == RgbColor.from(color);
  }

  /// Converts `this` to a [Color].
  Color toColor() {
    final rgb = RgbColor.from(this);

    return Color.fromRGBO(rgb.red, rgb.green, rgb.blue, 1.0);
  }

  /// Converts `this` to the CMYK color space.
  @override
  CmykColor toCmykColor() => CmykColor.from(this);

  /// Converts `this` to the HSI color space.
  @override
  HsiColor toHsiColor() => HsiColor.from(this);

  /// Converts `this` to the HSL color space.
  @override
  HslColor toHslColor() => HslColor.from(this);

  /// Converts `this` to the HSP color space.
  @override
  HspColor toHspColor() => HspColor.from(this);

  /// Converts `this` to the HSV color space.
  @override
  HsvColor toHsvColor() => HsvColor.from(this);

  /// Converts `this` to the LAB color space.
  @override
  LabColor toLabColor() => LabColor.from(this);

  /// Converts `this` to the RGB color space.
  @override
  RgbColor toRgbColor() => RgbColor.from(this);

  /// Converts `this` to the XYZ color space.
  @override
  XyzColor toXyzColor() => XyzColor.from(this);

  /// Copies a [ColorModel] from this plugin's library and
  /// returns it as a [ColorModel] from color_models' library.
  static ColorModel cast(ColorModel color) {
    assert(color != null);

    switch (color.runtimeType) {
      case CmykColor:
        color = cm.CmykColor.fromList(color.toList());
        break;
      case HsiColor:
        color = cm.HsiColor.fromList(color.toList());
        break;
      case HslColor:
        color = cm.HslColor.fromList(color.toList());
        break;
      case HspColor:
        color = cm.HspColor.fromList(color.toList());
        break;
      case HsvColor:
        color = cm.HsvColor.fromList(color.toList());
        break;
      case LabColor:
        color = cm.LabColor.fromList(color.toList());
        break;
      case RgbColor:
        color = cm.RgbColor.fromList(color.toList());
        break;
      case XyzColor:
        color = cm.XyzColor.fromList(color.toList());
        break;
    }

    return color;
  }
}
