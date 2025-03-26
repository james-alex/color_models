import 'dart:ui' as ui;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.LabColor}
class LabColor extends cm.LabColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// {@macro color_models.LabColor.constructor}
  const LabColor(
    num lightness,
    num a,
    num b, [
    int alpha = 255,
  ])  : assert(lightness >= 0 && lightness <= 100),
        assert(a >= -128 && a <= 127),
        assert(b >= -128 && b <= 127),
        assert(alpha >= 0 && alpha <= 255),
        super(lightness, a, b, alpha);

  @override
  int get value => toColor().value;

  @override
  LabColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<LabColor> lerpTo(
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
        .map<LabColor>((color) => color.cast())
        .toList();
  }

  @override
  LabColor get inverted => super.inverted.cast();

  @override
  LabColor get opposite => super.opposite.cast();

  @override
  LabColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  LabColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  LabColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  LabColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  /// Returns this [LabColor] modified with the provided [hue] value.
  @override
  LabColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toLabColor();
  }

  @override
  LabColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  LabColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toLabColor();
  }

  @override
  LabColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toLabColor();
  }

  @override
  LabColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toLabColor();
  }

  @override
  LabColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return LabColor(lightness, a, b, alpha);
  }

  @override
  LabColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  LabColor fromValues(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 100);
    assert(values[1] >= -128 && values[1] <= 127);
    assert(values[2] >= -128 && values[2] <= 127);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return LabColor.fromList(values);
  }

  @override
  LabColor withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color color = performWithValues(alpha, red, green, blue, colorSpace);
    return LabColor.fromColor(color);
  }

  @override
  LabColor copyWith({num? lightness, num? a, num? b, int? alpha}) {
    assert(lightness == null || (lightness >= 0 && lightness <= 100));
    assert(a == null || (a >= -128 && a <= 127));
    assert(b == null || (b >= -128 && b <= 127));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return LabColor(
      lightness ?? this.lightness,
      a ?? this.a,
      b ?? this.b,
      alpha ?? this.alpha,
    );
  }

  @override
  LabColor toLabColor() => this;

  /// {@macro color_models.LabColor.from}
  factory LabColor.from(cm.ColorModel color) => color.toLabColor().cast();

  /// {@macro color_models.LabColor.fromList}
  factory LabColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 100);
    assert(values[1] >= -128 && values[1] <= 127);
    assert(values[2] >= -128 && values[2] <= 127);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return LabColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [LabColor] from [color].
  factory LabColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toLabColor();

  /// {@macro color_models.LabColor.fromHex}
  factory LabColor.fromHex(String hex) => cm.LabColor.fromHex(hex).cast();

  /// {@macro color_models.LabColor.extrapolate}
  factory LabColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return LabColor(values[0] * 100, (values[1] * 255) - 128,
        (values[2] * 255) - 128, alpha);
  }

  /// {@macro color_models.LabColor.random}
  factory LabColor.random({
    num minLightness = 0,
    num maxLightness = 100,
    num minA = 0,
    num maxA = 100,
    num minB = 0,
    num maxB = 100,
    int? seed,
  }) {
    assert(minLightness >= 0 && minLightness <= maxLightness);
    assert(maxLightness >= minLightness && maxLightness <= 100);
    assert(minA >= 0 && minA <= maxA);
    assert(maxA >= minA && maxA <= 100);
    assert(minB >= 0 && minB <= maxB);
    assert(maxB >= minB && maxB <= 100);
    return cm.LabColor.random(
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
  LabColor convert(cm.ColorModel other) => other.toLabColor().cast();
    
}
