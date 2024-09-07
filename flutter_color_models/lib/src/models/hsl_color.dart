import 'dart:ui' as ui;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.HslColor}
class HslColor extends cm.HslColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// {@macro color_models.HslColor.constructor}
  const HslColor(
    num hue,
    num saturation,
    num lightness, [
    int alpha = 255,
  ])  : assert(hue >= 0 && hue <= 360),
        assert(saturation >= 0 && saturation <= 100),
        assert(lightness >= 0 && lightness <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(hue, saturation, lightness, alpha);

  @override
  int get value => toColor().value;

  @override
  HslColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<HslColor> lerpTo(
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
        .map<HslColor>((color) => color.cast())
        .toList();
  }

  @override
  HslColor get inverted => super.inverted.cast();

  @override
  HslColor get opposite => rotateHue(180);

  @override
  HslColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  HslColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  HslColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  HslColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  HslColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    return HslColor(hue, saturation, lightness, alpha);
  }

  @override
  HslColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  HslColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toHslColor();
  }

  @override
  HslColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toHslColor();
  }

  @override
  HslColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toHslColor();
  }

  @override
  HslColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return HslColor(hue, saturation, lightness, alpha);
  }

  @override
  HslColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }
  
  @override
  HslColor fromValues(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return HslColor.fromList(values);
  }

  @override
  HslColor withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color color = performWithValues(alpha, red, green, blue, colorSpace);
    return HslColor.fromColor(color);
  }

  @override
  HslColor copyWith({num? hue, num? saturation, num? lightness, int? alpha}) {
    assert(hue == null || (hue >= 0 && hue <= 360));
    assert(saturation == null || (saturation >= 0 && saturation <= 100));
    assert(lightness == null || (lightness >= 0 && lightness <= 100));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return HslColor(
      hue ?? this.hue,
      saturation ?? this.saturation,
      lightness ?? this.lightness,
      alpha ?? this.alpha,
    );
  }

  @override
  HslColor toHslColor() => this;

  /// {@macro color_models.HslColor.from}
  factory HslColor.from(cm.ColorModel color) => color.toHslColor().cast();

  /// {@macro color_models.HslColor.fromList}
  factory HslColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return HslColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [HslColor] from [color].
  factory HslColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toHslColor();

  /// {@macro color_models.HslColor.fromHex}
  factory HslColor.fromHex(String hex) => cm.HslColor.fromHex(hex).cast();

  /// {@macro color_models.HslColor.extrapolate}
  factory HslColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HslColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// {@macro color_models.HslColor.random}
  factory HslColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minLightness = 0,
    num maxLightness = 100,
    int? seed,
  }) {
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minLightness >= 0 && minLightness <= maxLightness);
    assert(maxLightness >= minLightness && maxLightness <= 100);
    return cm.HslColor.random(
      minHue: minHue,
      maxHue: maxHue,
      minSaturation: minSaturation,
      maxSaturation: maxSaturation,
      minLightness: minLightness,
      maxLightness: maxLightness,
      seed: seed,
    ).cast();
  }

  @override
  HslColor convert(cm.ColorModel other) => other.toHslColor().cast();

}
