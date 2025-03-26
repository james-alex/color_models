import 'package:color_models/color_models.dart' as cm;
import 'package:color_models/color_models.dart' show ColorSpace;
import 'package:flutter/painting.dart' show Color;
import 'dart:ui' as ui hide Color;
import 'package:meta/meta.dart';
import 'models/helpers/cast_to_color.dart';
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

  factory ColorModel(Color justUIColor) {
    return RgbColor.fromColor(justUIColor);
  }

  @override
  ColorModel interpolate(cm.ColorModel end, double step);

  @override
  List<ColorModel> lerpTo(
    cm.ColorModel color,
    int steps, {
    cm.ColorSpace? colorSpace,
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
  ColorModel rotateHueRad(double amount);

  @override
  ColorModel withHue(num hue);

  @override
  ColorModel withChroma(double chroma);

  @override
  ColorModel withAlpha(int alpha);

  @override
  ColorModel withOpacity(double opacity);

  @override
  ColorModel fromValues(List<num> values);

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

extension LerpToColor on Color {
  /// Returns the interpolated [steps] between this color and [color].
  ///
  /// The returned [Color]'s values will be interpolated in
  /// this color's color space.
  ///
  /// If [excludeOriginalColors] is `false`, this color and [color] will not be
  /// included in the list. If [color] is in a different color space, it will be
  /// converted to this color's color space.
  List<Color> lerpTo(
    Color color,
    int steps, {
    ColorSpace? colorSpace,
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return toRgbColor().lerpTo(color.toRgbColor(), steps,
        colorSpace: colorSpace, excludeOriginalColors: excludeOriginalColors);
  }

  /// Interpolates to the defined [step] between this color and [end].
  Color interpolate(Color end, double step) {
    return toRgbColor().interpolate(end.toRgbColor(), step).toColor();
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

  /// Returns this color as an [OklabColor].
  OklabColor toOklabColor() => OklabColor.fromColor(this);

  /// Returns this color as a [RgbColor].
  RgbColor toRgbColor() => RgbColor.fromColor(this);

  /// Returns this color as a [XyzColor].
  XyzColor toXyzColor() => XyzColor.fromColor(this);

  /// If `this` is a [ColorModel], return `this`, otherwise construct
  /// a new [RgbColor] from this [Color].
  ColorModel toColorModel() =>
      this is ColorModel ? this as ColorModel : RgbColor.fromColor(this);
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

  /// Returns a [ColorModel] in this color space from [values].
  ColorModel fromList(List<num> values) {
    late ColorModel newColor;

    switch (this) {
      case ColorSpace.cmyk:
        newColor = CmykColor.fromList(values);
        break;
      case ColorSpace.hsb:
        newColor = HsbColor.fromList(values);
        break;
      case ColorSpace.hsi:
        newColor = HsiColor.fromList(values);
        break;
      case ColorSpace.hsl:
        newColor = HslColor.fromList(values);
        break;
      case ColorSpace.hsp:
        newColor = HspColor.fromList(values);
        break;
      case ColorSpace.lab:
        newColor = LabColor.fromList(values);
        break;
      case ColorSpace.oklab:
        newColor = OklabColor.fromList(values.cast<double>());
        break;
      case ColorSpace.rgb:
        newColor = RgbColor.fromList(values);
        break;
      case ColorSpace.xyz:
        newColor = XyzColor.fromList(values);
        break;
    }

    return newColor;
  }

  String get name => toString().split('.').last;
}

extension AugmentColorModels on Iterable<ColorModel> {
  /// {@macro color_models.AugmentColorModels.augment}
  List<ColorModel> augment(
    int newLength, {
    List<double>? stops,
    ColorSpace? colorSpace,
    bool invert = false,
  }) {
    assert(stops == null || stops.length == length);
    return cast<cm.ColorModel>()
        .augment(newLength,
            stops: stops, colorSpace: colorSpace, invert: invert)
        .cast<ColorModel>();
  }

  /// {@macro color_models.AugumentColorModels.convertTo}
  List<ColorModel> convertTo(ColorSpace colorSpace) {
    return cast<cm.ColorModel>().convertTo(colorSpace).cast<ColorModel>();
  }

  /// Returns a new list containing all of the
  /// colors in this list casted to [Color]s.
  List<Color> toColors() => map<Color>((color) => color.toColor()).toList();

  /// {@macro color_models.AugumentColorModels.getColorAt}
  ColorModel getColorAt(double delta) {
    assert(isNotEmpty, 'A color can\'t be returned from an empty list.');
    assert(delta >= 0.0 && delta <= 1.0);
    return cast<cm.ColorModel>().getColorAt(delta).cast();
  }
}

extension AugmentColors on Iterable<Color> {
  /// {@macro colorModels.AugmentColorModels.augment}
  List<Color> augment(
    int newLength, {
    List<double>? stops,
    ColorSpace? colorSpace,
    bool invert = false,
  }) {
    assert(stops == null || stops.length == length);
    return toColorModels().cast<ColorModel>().augment(newLength,
        stops: stops, colorSpace: colorSpace, invert: invert);
  }

  /// Returns this iterable as a list of [ColorModel]s.
  List<ColorModel> toColorModels() =>
      map((color) => color.toColorModel()).toList();

  /// {@macro color_models.AugumentColorModels.getColorAt}
  ColorModel getColorAt(double delta) {
    assert(isNotEmpty, 'A color can\'t be returned from an empty list.');
    assert(delta >= 0.0 && delta <= 1.0);
    return toColorModels().getColorAt(delta);
  }
}
