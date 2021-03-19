import 'package:color_models/color_models.dart' as cm;
import 'package:color_models/color_models.dart' show ColorSpace;
import 'package:flutter/painting.dart' show Color;
import 'package:meta/meta.dart';
import 'models/cmyk_color.dart';
import 'models/hsb_color.dart';
import 'models/hsi_color.dart';
import 'models/hsl_color.dart';
import 'models/hsp_color.dart';
import 'models/lab_color.dart';
import 'models/oklab_color.dart';
import 'models/rgb_color.dart';
import 'models/xyz_color.dart';

export 'models/cmyk_color.dart';
export 'models/hsb_color.dart';
export 'models/hsi_color.dart';
export 'models/hsl_color.dart';
export 'models/hsp_color.dart';
export 'models/lab_color.dart';
export 'models/oklab_color.dart';
export 'models/rgb_color.dart';
export 'models/xyz_color.dart';

/// {@macro color_models.ColorModel}
@immutable
abstract class ColorModel implements cm.ColorModel, Color {
  @override
  ColorModel interpolate(cm.ColorModel end, double step);

  @override
  List<ColorModel> lerpTo(
    cm.ColorModel color,
    int steps, {
    bool excludeOriginalColors,
  });

  @override
  ColorModel get inverted;

  @override
  ColorModel get opposite;

  @override
  ColorModel warmer(num amount, {bool relative});

  @override
  ColorModel cooler(num amount, {bool relative});

  @override
  ColorModel rotateHue(num amount);

  @override
  ColorModel withHue(num hue);

  /// __NOTICE:__ [withAlpha] has been deprecated, use [copyWith] instead.
  @deprecated
  @override
  ColorModel withAlpha(int alpha);

  @override
  ColorModel withOpacity(double opacity);

  @override
  ColorModel withValues(List<num> values);

  @override
  ColorModel copyWith({int? alpha});

  @override
  CmykColor toCmykColor();

  @override
  HsiColor toHsiColor();

  @override
  HslColor toHslColor();

  @override
  HspColor toHspColor();

  @override
  HsbColor toHsbColor();

  @override
  LabColor toLabColor();

  @override
  OklabColor toOklabColor();

  @override
  RgbColor toRgbColor();

  @override
  XyzColor toXyzColor();

  @override
  ColorModel convert(cm.ColorModel other);
}

extension ToColor on cm.ColorModel {
  /// Returns `this` as a [Color], converting the color to RGB if necessary.
  Color toColor() {
    final rgb = RgbColor.from(this);
    return Color.fromARGB(rgb.alpha, rgb.red, rgb.green, rgb.blue);
  }
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

extension ConvertToColorSpace on ColorSpace {
  /// Converts [color] to this color space.
  ColorModel from(cm.ColorModel color) {
    late ColorModel newColor;

    switch (this) {
      case ColorSpace.cmyk:
        newColor = CmykColor.from(color);
        break;
      case ColorSpace.hsb:
        newColor = HsbColor.from(color);
        break;
      case ColorSpace.hsi:
        newColor = HsiColor.from(color);
        break;
      case ColorSpace.hsl:
        newColor = HslColor.from(color);
        break;
      case ColorSpace.hsp:
        newColor = HspColor.from(color);
        break;
      case ColorSpace.lab:
        newColor = LabColor.from(color);
        break;
      case ColorSpace.oklab:
        newColor = OklabColor.from(color);
        break;
      case ColorSpace.rgb:
        newColor = RgbColor.from(color);
        break;
      case ColorSpace.xyz:
        newColor = XyzColor.from(color);
        break;
    }

    return newColor;
  }

  /// Converts [color] to a [ColorModel] in this color space.
  ColorModel fromColor(Color color) {
    late ColorModel newColor;

    switch (this) {
      case ColorSpace.cmyk:
        newColor = CmykColor.fromColor(color);
        break;
      case ColorSpace.hsb:
        newColor = HsbColor.fromColor(color);
        break;
      case ColorSpace.hsi:
        newColor = HsiColor.fromColor(color);
        break;
      case ColorSpace.hsl:
        newColor = HslColor.fromColor(color);
        break;
      case ColorSpace.hsp:
        newColor = HspColor.fromColor(color);
        break;
      case ColorSpace.lab:
        newColor = LabColor.fromColor(color);
        break;
      case ColorSpace.oklab:
        newColor = OklabColor.fromColor(color);
        break;
      case ColorSpace.rgb:
        newColor = RgbColor.fromColor(color);
        break;
      case ColorSpace.xyz:
        newColor = XyzColor.fromColor(color);
        break;
    }

    return newColor;
  }

  String get name => toString().split('.').last;
}

extension AugmentColorModels on Iterable<ColorModel> {
  /// {@macro colorModels.AugmentColorModels.augment}
  List<ColorModel> augment(
    int newLength, {
    List<double>? stops,
    ColorSpace? colorSpace,
    bool reversed = false,
  }) {
    assert(stops == null || stops.length == length);
    return cast<cm.ColorModel>()
        .augment(newLength,
            stops: stops, colorSpace: colorSpace, reversed: reversed)
        .cast<ColorModel>();
  }
}

extension AugmentColors on Iterable<Color> {
  /// {@macro colorModels.AugmentColorModels.augment}
  List<Color> augment(
    int newLength, {
    List<double>? stops,
    ColorSpace? colorSpace,
    bool reversed = false,
  }) {
    final palette = List<Color>.from(this);

    // Cast any [Color]s in the list to [RgbColor]s.
    for (var i = 0; i < length; i++) {
      if (palette[i] is! ColorModel) {
        palette[i] = RgbColor.fromColor(palette[i]);
      }
    }

    return palette
        .cast<ColorModel>()
        .augment(newLength, colorSpace: colorSpace, reversed: reversed);
  }
}
