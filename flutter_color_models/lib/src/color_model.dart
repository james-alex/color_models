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
  ColorModel withValuesList(List<num> values);

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

abstract class UICloned_ColorTransform {
  Color transform(Color color, ui.ColorSpace resultColorSpace);
}

class UICloned_IdentityColorTransform implements UICloned_ColorTransform {
  const UICloned_IdentityColorTransform();
  @override
  Color transform(Color color, ui.ColorSpace resultColorSpace) => color;
}

class UICloned_ClampTransform implements UICloned_ColorTransform {
  const UICloned_ClampTransform(this.child);
  final UICloned_ColorTransform child;
  @override
  Color transform(Color color, ui.ColorSpace resultColorSpace) {
    return Color.from(
      alpha: ui.clampDouble(color.a, 0, 1),
      red: ui.clampDouble(color.r, 0, 1),
      green: ui.clampDouble(color.g, 0, 1),
      blue: ui.clampDouble(color.b, 0, 1),
      colorSpace: resultColorSpace);
  }
}

class UICloned_MatrixColorTransform implements UICloned_ColorTransform {
  /// Row-major.
  const UICloned_MatrixColorTransform(this.values);

  final List<double> values;

  @override
  Color transform(Color color, ui.ColorSpace resultColorSpace) {
    return Color.from(
        alpha: color.a,
        red: values[0] * color.r +
            values[1] * color.g +
            values[2] * color.b +
            values[3],
        green: values[4] * color.r +
            values[5] * color.g +
            values[6] * color.b +
            values[7],
        blue: values[8] * color.r +
            values[9] * color.g +
            values[10] * color.b +
            values[11],
        colorSpace: resultColorSpace);
  }
}

UICloned_ColorTransform UICloned_getColorTransform(ui.ColorSpace source, ui.ColorSpace destination) {
  // The transforms were calculated with the following octave script from known
  // conversions. These transforms have a white point that matches Apple's.
  //
  // p3Colors = [
  //   1, 0, 0, 0.25;
  //   0, 1, 0, 0.5;
  //   0, 0, 1, 0.75;
  //   1, 1, 1, 1;
  // ];
  // srgbColors = [
  //   1.0930908918380737,  -0.5116420984268188, -0.0003518527664709836, 0.12397786229848862;
  //   -0.22684034705162048, 1.0182716846466064,  0.00027732315356843174,  0.5073589086532593;
  //   -0.15007957816123962, -0.31062406301498413, 1.0420056581497192,  0.771118700504303;
  //   1,       1,       1,       1;
  // ];
  //
  // format long
  // p3ToSrgb = srgbColors * inv(p3Colors)
  // srgbToP3 = inv(p3ToSrgb)
  const UICloned_MatrixColorTransform srgbToP3 = UICloned_MatrixColorTransform(<double>[
    0.808052267214446, 0.220292047628890, -0.139648846160100,
    0.145738111193222, //
    0.096480880462996, 0.916386732581291, -0.086093928394828,
    0.089490172325882, //
    -0.127099563510240, -0.068983484963878, 0.735426667591299, 0.233655661600230
  ]);
  const UICloned_ColorTransform p3ToSrgb = UICloned_MatrixColorTransform(<double>[
    1.306671048092539, -0.298061942172353, 0.213228303487995,
    -0.213580156254466, //
    -0.117390025596251, 1.127722006101976, 0.109727644608938,
    -0.109450321455370, //
    0.214813187718391, 0.054268702864647, 1.406898424029350, -0.364892765879631
  ]);
  switch (source) {
    case ui.ColorSpace.sRGB:
      switch (destination) {
        case ui.ColorSpace.sRGB:
          return const UICloned_IdentityColorTransform();
        case ui.ColorSpace.extendedSRGB:
          return const UICloned_IdentityColorTransform();
        case ui.ColorSpace.displayP3:
          return srgbToP3;
      }
    case ui.ColorSpace.extendedSRGB:
      switch (destination) {
        case ui.ColorSpace.sRGB:
          return const UICloned_ClampTransform(UICloned_IdentityColorTransform());
        case ui.ColorSpace.extendedSRGB:
          return const UICloned_IdentityColorTransform();
        case ui.ColorSpace.displayP3:
          return const UICloned_ClampTransform(srgbToP3);
      }
    case ui.ColorSpace.displayP3:
      switch (destination) {
        case ui.ColorSpace.sRGB:
          return const UICloned_ClampTransform(p3ToSrgb);
        case ui.ColorSpace.extendedSRGB:
          return p3ToSrgb;
        case ui.ColorSpace.displayP3:
          return const UICloned_IdentityColorTransform();
      }
  }
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
        colorSpace: colorSpace, excludeOriginalColors: excludeOriginalColors) as List<Color>;
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
        stops: stops, colorSpace: colorSpace, invert: invert) as List<Color>;
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
