import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// A color in the HSI color space.
///
/// The HSI color space contains channels for [hue],
/// [saturation], and [intensity].
class HsiColor extends cm.HsiColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// A color in the HSI color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [intensity] must both be `>= 0` and `<= 100`.
  const HsiColor(
    num hue,
    num saturation,
    num intensity, [
    int alpha = 255,
  ])  : assert(hue >= 0 && hue <= 360),
        assert(saturation >= 0 && saturation <= 100),
        assert(intensity >= 0 && intensity <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(hue, saturation, intensity, alpha);

  @override
  int get value => toColor().value;

  @override
  HsiColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<HsiColor> lerpTo(
    cm.ColorModel color,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps, excludeOriginalColors: excludeOriginalColors)
        .map<HsiColor>((color) => color.cast())
        .toList();
  }

  @override
  HsiColor get inverted => super.inverted.cast();

  @override
  HsiColor get opposite => super.opposite.cast();

  @override
  HsiColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  HsiColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  HsiColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  HsiColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    return HsiColor(hue, saturation, intensity, alpha);
  }

  @override
  HsiColor withSaturation(num saturation) {
    assert(saturation >= 0 && saturation <= 100);
    return HsiColor(hue, saturation, intensity, alpha);
  }

  @override
  HsiColor withIntensity(num intensity) {
    assert(intensity >= 0 && intensity <= 100);
    return HsiColor(hue, saturation, intensity, alpha);
  }

  @override
  HsiColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toHsiColor();
  }

  @override
  HsiColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toHsiColor();
  }

  @override
  HsiColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toHsiColor();
  }

  @override
  HsiColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return HsiColor(hue, saturation, intensity, alpha);
  }

  @override
  HsiColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((opacity * 255).round());
  }

  @override
  HsiColor toHsiColor() => this;

  /// Constructs a [HsiColor] from [color].
  factory HsiColor.from(cm.ColorModel color) => color.toHsiColor().cast();

  /// Constructs a [HsiColor] from a list of [hsi] values.
  ///
  /// [hsi] must not be null and must have exactly `3` or `4` values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and intensity must both be `>= 0` and `<= 100`.
  factory HsiColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return HsiColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [HsiColor] from [color].
  factory HsiColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toHsiColor();

  /// Constructs a [HsiColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory HsiColor.fromHex(String hex) => cm.HsiColor.fromHex(hex).cast();

  /// Constructs a [HsiColor] from a list of [hsi] values on a `0` to `1` scale.
  ///
  /// [hsi] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory HsiColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HsiColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// Generates a [HsiColor] at random.
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
  /// [minIntensity] and [maxIntensity] constrain the generated [intensity]
  /// value.
  ///
  /// Min and max values, besides hues, must be `min <= max && max >= min`,
  /// must be in the range of `>= 0 && <= 100`, and must not be `null`.
  factory HsiColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minIntensity = 0,
    num maxIntensity = 100,
  }) {
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minIntensity >= 0 && minIntensity <= maxIntensity);
    assert(maxIntensity >= minIntensity && maxIntensity <= 100);
    return cm.HsiColor.random(
      minHue: minHue,
      maxHue: maxHue,
      minSaturation: minSaturation,
      maxSaturation: maxSaturation,
      minIntensity: minIntensity,
      maxIntensity: maxIntensity,
    ).cast();
  }
}
