import 'dart:ui' as ui;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.RgbColor}
class RgbColor extends cm.RgbColor
    with AsColor, CastToColor
    implements ColorModel {
  /// {@macro color_models.RgbColor.constructor}
  const RgbColor(
    num red,
    num green,
    num blue, [
    int alpha = 255,
  ])  : assert(red >= 0 && red <= 255),
        assert(green >= 0 && green <= 255),
        assert(blue >= 0 && green <= 255),
        assert(alpha >= 0 && alpha <= 255),
        super(red, green, blue, alpha);

  @override
  int get value => toColor().value;

  @override
  double get a => alpha / 255.0;

  @override
  double get r => red / 255.0;

  @override
  double get g => green / 255.0;

  @override
  double get b => blue / 255.0;

  @override
  RgbColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<RgbColor> lerpTo(
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
        .map<RgbColor>((color) => color.cast())
        .toList();
  }

  @override
  RgbColor get inverted => super.inverted.cast();

  @override
  RgbColor get opposite => super.opposite.cast();

  @override
  RgbColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  RgbColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  RgbColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  RgbColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  /// Returns this [RgbColor] modified with the provided [hue] value.
  @override
  RgbColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toRgbColor();
  }

  @override
  RgbColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  RgbColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return RgbColor(red, green, blue, alpha);
  }

  @override
  RgbColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return RgbColor(red, green, blue, alpha);
  }

  @override
  RgbColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return RgbColor(red, green, blue, alpha);
  }

  @override
  RgbColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return RgbColor(red, green, blue, alpha);
  }

  @override
  RgbColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  RgbColor fromValues(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 255);
    assert(values[1] >= 0 && values[1] <= 255);
    assert(values[2] >= 0 && values[2] <= 255);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return RgbColor.fromList(values);
  }

  @override
  RgbColor withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color color = performWithValues(alpha, red, green, blue, colorSpace);
    return RgbColor.fromColor(color);
  }

  @override
  RgbColor copyWith({num? red, num? green, num? blue, int? alpha}) {
    assert(red == null || (red >= 0 && red <= 255));
    assert(green == null || (green >= 0 && green <= 255));
    assert(blue == null || (blue >= 0 && blue <= 255));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return RgbColor(
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
      alpha ?? this.alpha,
    );
  }

  @override
  RgbColor toRgbColor() => this;

  /// {@macro color_models.RgbColor.from}
  factory RgbColor.from(cm.ColorModel color) => color.toRgbColor().cast();

  /// {@macro color_models.RgbColor.fromList}
  factory RgbColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 255);
    assert(values[1] >= 0 && values[1] <= 255);
    assert(values[2] >= 0 && values[2] <= 255);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return RgbColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [RgbColor] from [color].
  factory RgbColor.fromColor(Color color) =>
      RgbColor(color.red, color.green, color.blue, color.alpha);

  /// {@macro color_models.RgbColor.fromHex}
  factory RgbColor.fromHex(String hex) => cm.RgbColor.fromHex(hex).cast();

  /// {@macro color_models.RgbColor.extrapolate}
  factory RgbColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return RgbColor(values[0] * 255, values[1] * 255, values[2] * 255, alpha);
  }

  /// {@macro color_models.RgbColor.random}
  factory RgbColor.random({
    int minRed = 0,
    int maxRed = 255,
    int minGreen = 0,
    int maxGreen = 255,
    int minBlue = 0,
    int maxBlue = 255,
    int? seed,
  }) {
    assert(minRed >= 0 && minRed <= maxRed);
    assert(maxRed >= minRed && maxRed <= 255);
    assert(minGreen >= 0 && minGreen <= maxGreen);
    assert(maxGreen >= minGreen && maxGreen <= 255);
    assert(minBlue >= 0 && minBlue <= maxBlue);
    assert(maxBlue >= minBlue && maxBlue <= 255);
    return cm.RgbColor.random(
      minRed: minRed,
      maxRed: maxRed,
      minGreen: minGreen,
      maxGreen: maxGreen,
      minBlue: minBlue,
      maxBlue: maxBlue,
      seed: seed,
    ).cast();
  }

  @override
  RgbColor convert(cm.ColorModel other) => other.toRgbColor().cast();
  
}
