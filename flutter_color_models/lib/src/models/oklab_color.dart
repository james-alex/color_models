import 'dart:ui' as ui;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.OklabColor}
class OklabColor extends cm.OklabColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// {@macro color_models.OklabColor.constructor}
  const OklabColor(
    double lightness,
    double a,
    double b, [
    int alpha = 255,
  ])  : assert(alpha >= 0 && alpha <= 255),
        super(lightness, a, b, alpha);

  @override
  int get value => toColor().value;

  @override
  OklabColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<OklabColor> lerpTo(
    cm.ColorModel color,
    int steps, {
    cm.ColorSpace? colorSpace,
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps,
            colorSpace: colorSpace,
            excludeOriginalColors: excludeOriginalColors)
        .map<OklabColor>((color) => color.cast())
        .toList();
  }

  @override
  OklabColor get inverted => super.inverted.cast();

  @override
  OklabColor get opposite => super.opposite.cast();

  @override
  OklabColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  OklabColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  OklabColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  OklabColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  /// Returns this [LabColor] modified with the provided [hue] value.
  @override
  OklabColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toOklabColor();
  }

  @override
  OklabColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  OklabColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toOklabColor();
  }

  @override
  OklabColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toOklabColor();
  }

  @override
  OklabColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toOklabColor();
  }

  @override
  OklabColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return OklabColor(lightness, chromaticityA, chromaticityB, alpha);
  }

  @override
  OklabColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  OklabColor fromValues(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return OklabColor.fromList(
        values.map<double>((value) => value.toDouble()).toList());
  }

  OklabColor withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color color = performWithValues(alpha, red, green, blue, colorSpace);
    return OklabColor.fromColor(color);
  }
  
  @override
  OklabColor copyWith({num? lightness, num? a, num? b, int? alpha}) {
    assert(lightness == null || (lightness >= 0.0 && lightness <= 1.0));
    assert(a == null || (a >= 0.0 && a <= 1.0));
    assert(b == null || (b >= 0.0 && b <= 1.0));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return OklabColor(
      lightness?.toDouble() ?? this.lightness,
      a?.toDouble() ?? this.chromaticityA,
      b?.toDouble() ?? this.chromaticityB,
      alpha ?? this.alpha,
    );
  }

  @override
  OklabColor toOklabColor() => this;

  /// {@macro color_models.OklabColor.from}
  factory OklabColor.from(cm.ColorModel color) => color.toOklabColor().cast();

  /// {@macro color_models.OklabColor.fromList}
  factory OklabColor.fromList(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return OklabColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs an [OklabColor] from [color].
  factory OklabColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toOklabColor();

  /// {@macro color_models.OklabColor.fromHex}
  factory OklabColor.fromHex(String hex) => cm.OklabColor.fromHex(hex).cast();

  /// {@macro color_models.OklabColor.random}
  factory OklabColor.random({
    double minLightness = 0.0,
    double maxLightness = 1.0,
    double minA = 0.0,
    double maxA = 1.0,
    double minB = 0.0,
    double maxB = 1.0,
    int? seed,
  }) {
    return cm.OklabColor.random(
      minLightness: minLightness,
      maxLightness: maxLightness,
      minA: minA,
      maxA: maxA,
      minB: minB,
      maxB: maxB,
      seed: seed,
    ).cast();
  }

  @override
  OklabColor convert(cm.ColorModel other) => other.toOklabColor().cast();
    
}
