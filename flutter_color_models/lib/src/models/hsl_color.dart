import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// A color in the HSL color space.
///
/// The HSL color space contains channels for [hue],
/// [saturation], and [lightness].
class HslColor extends cm.HslColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// A color in the HSL color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [lightness] must both be `>= 0` and `<= 100`.
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
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps, excludeOriginalColors: excludeOriginalColors)
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

  @deprecated
  @override
  HslColor withSaturation(num saturation) {
    assert(saturation >= 0 && saturation <= 100);
    return HslColor(hue, saturation, lightness, alpha);
  }

  @deprecated
  @override
  HslColor withLightness(num lightness) {
    assert(lightness >= 0 && lightness <= 100);
    return HslColor(hue, saturation, lightness, alpha);
  }

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

  @deprecated
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
  HslColor withValues(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return HslColor.fromList(values);
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

  /// Constructs a [HslColor] from [color].
  factory HslColor.from(cm.ColorModel color) => color.toHslColor().cast();

  /// Constructs a [HslColor] from a list of [hsl] values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and lightness must both be `>= 0` and `<= 100`.
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

  /// Constructs a [HslColor] from a RGB [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory HslColor.fromHex(String hex) => cm.HslColor.fromHex(hex).cast();

  /// Constructs a [HslColor] from a list of [hsl] values on a `0` to `1` scale.
  ///
  /// [hsl] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory HslColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HslColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// Generates a [HslColor] at random.
  ///
  /// [minHue] and [maxHue] constrain the generated [hue] value. If
  /// `minHue < maxHue`, the range will run in a clockwise direction
  /// between the two, however if `minHue > maxHue`, the range will
  /// run in a counter-clockwise direction. Both [minHue] and [maxHue]
  /// must be `>= 0 && <= 360` and must not be `null`.
  ///
  /// [minSaturation] and [maxSaturation] constrain the generated [saturation]
  /// value.
  ///
  /// [minLightness] and [maxLightness] constrain the generated [lightness]
  /// value.
  ///
  /// Min and max values, besides hues, must be `min <= max && max >= min`,
  /// must be in the range of `>= 0 && <= 100`, and must not be `null`.
  factory HslColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minLightness = 0,
    num maxLightness = 100,
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
    ).cast();
  }

  @override
  HslColor convert(cm.ColorModel other) => other.toHslColor().cast();
}
