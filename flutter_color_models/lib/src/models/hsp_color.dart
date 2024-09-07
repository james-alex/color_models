import 'dart:ui' as ui;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.HspColor}
class HspColor extends cm.HspColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// {@macro color_models.HspColor.constructor}
  const HspColor(
    num hue,
    num saturation,
    num perceivedBrightness, [
    int alpha = 255,
  ])  : assert(hue >= 0 && hue <= 360),
        assert(saturation >= 0 && saturation <= 100),
        assert(perceivedBrightness >= 0 && perceivedBrightness <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(hue, saturation, perceivedBrightness, alpha);

  @override
  int get value => toColor().value;

  @override
  HspColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<HspColor> lerpTo(
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
        .map<HspColor>((color) => color.cast())
        .toList();
  }

  @override
  HspColor get inverted => super.inverted.cast();

  @override
  HspColor get opposite => super.opposite.cast();

  @override
  HspColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  HspColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  HspColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  HspColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  HspColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  @override
  HspColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  HspColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toHspColor();
  }

  @override
  HspColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toHspColor();
  }

  @override
  HspColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toHspColor();
  }

  @override
  HspColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  @override
  HspColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  HspColor fromValues(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return HspColor.fromList(values);
  }

  @override
  HspColor withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color color = performWithValues(alpha, red, green, blue, colorSpace);
    return HspColor.fromColor(color);
  }

  @override
  HspColor copyWith({
    num? hue,
    num? saturation,
    num? perceivedBrightness,
    int? alpha,
  }) {
    assert(hue == null || (hue >= 0 && hue <= 360));
    assert(saturation == null || (saturation >= 0 && saturation <= 100));
    assert(perceivedBrightness == null ||
        (perceivedBrightness >= 0 && perceivedBrightness <= 100));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return HspColor(
      hue ?? this.hue,
      saturation ?? this.saturation,
      perceivedBrightness ?? this.perceivedBrightness,
      alpha ?? this.alpha,
    );
  }

  @override
  HspColor toHspColor() => this;

  /// {@macro color_models.HspColor.from}
  factory HspColor.from(cm.ColorModel color) => color.toHspColor().cast();

  /// {@macro color_models.HspColor.fromList}
  factory HspColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return HspColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [HspColor] from [color].
  factory HspColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toHspColor();

  /// {@macro color_models.HspColor.fromHex}
  factory HspColor.fromHex(String hex) => cm.HspColor.fromHex(hex).cast();

  /// {@macro color_models.HspColor.extrapolate}
  factory HspColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HspColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// {@macro color_models.HspColor.random}
  factory HspColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minPerceivedBrightness = 0,
    num maxPerceivedBrightness = 100,
    int? seed,
  }) {
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minPerceivedBrightness >= 0 &&
        minPerceivedBrightness <= maxPerceivedBrightness);
    assert(maxPerceivedBrightness >= minPerceivedBrightness &&
        maxPerceivedBrightness <= 100);
    return cm.HspColor.random(
      minHue: minHue,
      maxHue: maxHue,
      minSaturation: minSaturation,
      maxSaturation: maxSaturation,
      minPerceivedBrightness: minPerceivedBrightness,
      maxPerceivedBrightness: maxPerceivedBrightness,
      seed: seed,
    ).cast();
  }

  @override
  HspColor convert(cm.ColorModel other) => other.toHspColor().cast();
    
}
