import 'dart:ui' as ui;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.XyzColor}
class XyzColor extends cm.XyzColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// /// {@macro color_models.XyzColor.constructor}
  const XyzColor(
    num x,
    num y,
    num z, [
    int alpha = 255,
  ])  : assert(x >= 0),
        assert(y >= 0),
        assert(z >= 0),
        assert(alpha >= 0 && alpha <= 255),
        super(x, y, z, alpha);

  @override
  int get value => toColor().value;

  @override
  XyzColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<XyzColor> lerpTo(
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
        .map<XyzColor>((color) => color.cast())
        .toList();
  }

  @override
  XyzColor get inverted => super.inverted.cast();

  @override
  XyzColor get opposite => super.opposite.cast();

  @override
  XyzColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  XyzColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  XyzColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  XyzColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  /// Returns this [XyzColor] modified with the provided [hue] value.
  @override
  XyzColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toXyzColor();
  }

  @override
  XyzColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  XyzColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toXyzColor();
  }

  @override
  XyzColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toXyzColor();
  }

  @override
  XyzColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toXyzColor();
  }

  @override
  XyzColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return XyzColor(x, y, z, alpha);
  }

  @override
  XyzColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  XyzColor fromValues(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 100);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return XyzColor.fromList(values);
  }

  @override
  XyzColor withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color color = performWithValues(alpha, red, green, blue, colorSpace);
    return XyzColor.fromColor(color);
  }

  @override
  XyzColor copyWith({
    num? x,
    num? y,
    num? z,
    int? alpha,
  }) {
    assert(x == null || x >= 0);
    assert(y == null || y >= 0);
    assert(z == null || z >= 0);
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return XyzColor(
      x ?? this.x,
      y ?? this.y,
      z ?? this.z,
      alpha ?? this.alpha,
    );
  }

  @override
  XyzColor toXyzColor() => this;

  /// {@macro color_models.XyzColor.from}
  factory XyzColor.from(cm.ColorModel color) => color.toXyzColor().cast();

  /// {@macro color_models.XyzColor.fromList}
  factory XyzColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 100);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return XyzColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [XyzColor] from [color].
  factory XyzColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toXyzColor();

  /// {@macro color_models.XyzColor.fromHex}
  factory XyzColor.fromHex(String hex) => cm.XyzColor.fromHex(hex).cast();

  /// {@macro color_models.XyzColor.extrapolate}
  factory XyzColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return XyzColor(values[0] * 100, values[1] * 100, values[2] * 100, alpha);
  }

  /// {@macro color_models.XyzColor.random}
  factory XyzColor.random({
    num minX = 0,
    num maxX = 100,
    num minY = 0,
    num maxY = 100,
    num minZ = 0,
    num maxZ = 100,
    int? seed,
  }) {
    assert(minX >= 0 && minX <= maxX);
    assert(maxX >= minX && maxX <= 100);
    assert(minY >= 0 && minY <= maxY);
    assert(maxY >= minY && maxY <= 100);
    assert(minZ >= 0 && minZ <= maxZ);
    assert(maxZ >= minZ && maxZ <= 100);
    return cm.XyzColor.random(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      minZ: minZ,
      maxZ: maxZ,
      seed: seed,
    ).cast();
  }

  @override
  XyzColor convert(cm.ColorModel other) => other.toXyzColor().cast();
    
}
