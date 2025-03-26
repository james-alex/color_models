import 'dart:ui' as ui;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.HsbColor}
class HsbColor extends cm.HsbColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {

  /// {@macro color_models.HsbColor.constructor}
  const HsbColor(
    num hue,
    num saturation,
    num brightness, [
    int alpha = 255,
  ])  : assert(hue >= 0 && hue <= 360),
        assert(saturation >= 0 && saturation <= 100),
        assert(brightness >= 0 && brightness <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(hue, saturation, brightness, alpha);

  @override
  int get value => toColor().value;

  @override
  HsbColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<HsbColor> lerpTo(
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
        .map<HsbColor>((color) => color.cast())
        .toList();
  }

  @override
  HsbColor get inverted => super.inverted.cast();

  @override
  HsbColor get opposite => super.opposite.cast();

  @override
  HsbColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  HsbColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  HsbColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  HsbColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  HsbColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    return HsbColor(hue, saturation, brightness, alpha);
  }

  @override
  HsbColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  HsbColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toHsbColor();
  }

  @override
  HsbColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toHsbColor();
  }

  @override
  HsbColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toHsbColor();
  }

  @override
  HsbColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return HsbColor(hue, saturation, brightness, alpha);
  }

  @override
  HsbColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  HsbColor fromValues(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return HsbColor.fromList(values);
  }

  @override
  HsbColor withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color color = performWithValues(alpha, red, green, blue, colorSpace);
    return HsbColor.fromColor(color);
  }

  @override
  HsbColor copyWith({
    num? hue,
    num? saturation,
    num? brightness,
    int? alpha,
  }) {
    assert(hue == null || (hue >= 0 && hue <= 360));
    assert(saturation == null || (saturation >= 0 && saturation <= 100));
    assert(brightness == null || (brightness >= 0 && brightness <= 100));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return HsbColor(
      hue ?? this.hue,
      saturation ?? this.saturation,
      brightness ?? this.brightness,
      alpha ?? this.alpha,
    );
  }

  @override
  HsbColor toHsbColor() => this;

  /// {@macro color_models.HsbColor.from}
  factory HsbColor.from(cm.ColorModel color) => color.toHsbColor().cast();

  /// {@macro color_models.HsbColor.fromList}
  factory HsbColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return HsbColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [HslColor] from [color].
  factory HsbColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toHsbColor();

  /// {@macro color_models.HsbColor.fromHex}
  factory HsbColor.fromHex(String hex) => cm.HsbColor.fromHex(hex).cast();

  /// {@macro color_models.HsbColor.extrapolate}
  factory HsbColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HsbColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// {@macro color_models.HsbColor.random}
  factory HsbColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minBrightness = 0,
    num maxBrightness = 100,
    int? seed,
  }) {
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minBrightness >= 0 && minBrightness <= maxBrightness);
    assert(maxBrightness >= minBrightness && maxBrightness <= 100);
    return cm.HsbColor.random(
      minHue: minHue,
      maxHue: maxHue,
      minSaturation: minSaturation,
      maxSaturation: maxSaturation,
      minBrightness: minBrightness,
      maxBrightness: maxBrightness,
      seed: seed,
    ).cast();
  }

  @override
  HsbColor convert(cm.ColorModel other) => other.toHsbColor().cast();
  
}
