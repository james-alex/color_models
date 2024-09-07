import 'dart:ui' as ui hide Color;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.CmykColor}
class CmykColor extends cm.CmykColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// {@macro color_models.CmykColor.constructor}
  const CmykColor(
    num cyan,
    num magenta,
    num yellow,
    num black, [
    int alpha = 255,
  ])  : assert(cyan >= 0 && cyan <= 100),
        assert(magenta >= 0 && magenta <= 100),
        assert(yellow >= 0 && yellow <= 100),
        assert(black >= 0 && black <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(cyan, magenta, yellow, black, alpha);

  @override
  int get value => toColor().value;

  @override
  CmykColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<CmykColor> lerpTo(
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
        .map<CmykColor>((color) => color.cast())
        .toList();
  }

  @override
  CmykColor get inverted => super.inverted.cast();

  @override
  CmykColor get opposite => super.opposite.cast();

  @override
  CmykColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  CmykColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  CmykColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  CmykColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  CmykColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toCmykColor();
  }

  @override
  CmykColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  CmykColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toCmykColor();
  }

  @override
  CmykColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toCmykColor();
  }

  @override
  CmykColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toCmykColor();
  }

  @override
  CmykColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  @override
  CmykColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  CmykColor fromValues(List<num> values) {
    assert(values.length == 4 || values.length == 5);
    assert(values[0] >= 0 && values[0] <= 100);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    assert(values[3] >= 0 && values[3] <= 100);
    return CmykColor.fromList(values);
  }

  @override
  CmykColor withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color color = performWithValues(alpha, red, green, blue, colorSpace);
    return CmykColor.fromColor(color);
  }

  @override
  CmykColor copyWith({
    num? cyan,
    num? magenta,
    num? yellow,
    num? black,
    int? alpha,
  }) {
    assert(cyan == null || (cyan >= 0 && cyan <= 100));
    assert(magenta == null || (magenta >= 0 && magenta <= 100));
    assert(yellow == null || (yellow >= 0 && yellow <= 100));
    assert(black == null || (black >= 0 && black <= 100));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return CmykColor(
      cyan ?? this.cyan,
      magenta ?? this.magenta,
      yellow ?? this.yellow,
      black ?? this.black,
      alpha ?? this.alpha,
    );
  }

  @override
  CmykColor toCmykColor() => this;

  /// {@macro color_models.CmykColor.from}
  factory CmykColor.from(cm.ColorModel color) => color.toCmykColor().cast();

  /// {@macro color_models.CmykColor.fromValues}
  factory CmykColor.fromList(List<num> values) {
    assert(values.length == 4 || values.length == 5);
    assert(values[0] >= 0 && values[0] <= 100);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    assert(values[3] >= 0 && values[3] <= 100);
    if (values.length == 5) assert(values[4] >= 0 && values[4] <= 255);
    final alpha = values.length == 5 ? values[4].round() : 255;
    return CmykColor(values[0], values[1], values[2], values[3], alpha);
  }

  /// Constructs a [CmykColor] from [color].
  factory CmykColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toCmykColor();

  /// {@macro color_models.CmykColor.fromHex}
  factory CmykColor.fromHex(String hex) => cm.CmykColor.fromHex(hex).cast();

  /// {@macro color_models.CmykColor.extrapolate}
  factory CmykColor.extrapolate(List<double> values) {
    assert(values.length == 4 || values.length == 5);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    assert(values[3] >= 0 && values[3] <= 1);
    if (values.length == 5) assert(values[4] >= 0 && values[4] <= 1);
    final alpha = values.length == 5 ? (values[4] * 255).round() : 255;
    return CmykColor(values[0] * 100, values[1] * 100, values[2] * 100,
        values[3] * 100, alpha);
  }

  /// {@macro color_models.CmykColor.random}
  factory CmykColor.random({
    num minCyan = 0,
    num maxCyan = 100,
    num minMagenta = 0,
    num maxMagenta = 100,
    num minYellow = 0,
    num maxYellow = 100,
    num minBlack = 0,
    num maxBlack = 100,
    int? seed,
  }) {
    assert(minCyan >= 0 && minCyan <= maxCyan);
    assert(maxCyan >= minCyan && maxCyan <= 100);
    assert(minMagenta >= 0 && minMagenta <= maxMagenta);
    assert(maxMagenta >= minMagenta && maxMagenta <= 100);
    assert(minYellow >= 0 && minYellow <= maxYellow);
    assert(maxYellow >= minYellow && maxYellow <= 100);
    assert(minBlack >= 0 && minBlack <= maxBlack);
    assert(maxBlack >= minBlack && maxBlack <= 100);
    return cm.CmykColor.random(
      minCyan: minCyan,
      maxCyan: maxCyan,
      minMagenta: minMagenta,
      maxMagenta: maxMagenta,
      minYellow: minYellow,
      maxYellow: maxYellow,
      minBlack: minBlack,
      maxBlack: maxBlack,
      seed: seed,
    ).cast();
  }

  @override
  CmykColor convert(cm.ColorModel other) => other.toCmykColor().cast();
  
}
