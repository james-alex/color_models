import 'dart:math';
import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';
import '../helpers/color_math.dart';

/// {@template color_models.HsbColor}
///
/// A color in the hsb (HSB) color space.
///
/// The hsb color space contains channels for [hue],
/// [saturation], and [brightness].
///
/// {@endtemplate}
@immutable
class HsbColor extends ColorModel {
  /// {@template color_models.HsbColor.constructor}
  ///
  /// A color in the hsb (HSB) color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [brightness] must both be `>= 0` and `<= 100`.
  ///
  /// [alpha] must be `>= 0` and `<= 255`.
  ///
  /// {@endtemplate}
  const HsbColor(
    this.hue,
    this.saturation,
    this.brightness, [
    int alpha = 255,
  ])  : assert(hue >= 0 && hue <= 360),
        assert(saturation >= 0 && saturation <= 100),
        assert(brightness >= 0 && brightness <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(alpha: alpha);

  /// The hue value of this color.
  ///
  /// Ranges from `0` to `360`.
  @override
  final num hue;

  /// The saturation value of this color.
  ///
  /// Ranges from `0` to `100`.
  @override
  final num saturation;

  /// The brightness value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num brightness;

  @override
  bool get isBlack => ColorMath.round(brightness) == 0;

  @override
  bool get isWhite =>
      ColorMath.round(saturation) == 0 && ColorMath.round(brightness) == 1;

  @override
  bool get isMonochromatic =>
      ColorMath.round(brightness) == 0 || ColorMath.round(saturation) == 0;

  @override
  HsbColor interpolate(ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step) as HsbColor;
  }

  @override
  List<HsbColor> lerpTo(
    ColorModel color,
    int steps, {
    ColorSpace? colorSpace,
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps,
            colorSpace: colorSpace,
            excludeOriginalColors: excludeOriginalColors)
        .cast<HsbColor>();
  }

  /// Adjusts this colors [hue] by `180` degrees while inverting the
  /// [saturation] and [brightness] values.
  @override
  HsbColor get inverted =>
      HsbColor((hue + 180) % 360, 100 - saturation, 100 - brightness, alpha);

  @override
  HsbColor get opposite => rotateHue(180);

  @override
  HsbColor rotateHue(num amount) => withHue((hue + amount) % 360);

  @override
  HsbColor rotateHueRad(double amount) =>
      withHue((hue + (amount * 180 / pi)) % 360);

  @override
  HsbColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    if (relative) assert(amount <= 100);
    return withHue(ColorAdjustments.warmerHue(hue, amount, relative: relative));
  }

  @override
  HsbColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    if (relative) assert(amount <= 100);
    return withHue(ColorAdjustments.coolerHue(hue, amount, relative: relative));
  }

  /// Returns this [HsbColor] modified with the provided [hue] value.
  @override
  HsbColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    return HsbColor(hue, saturation, brightness, alpha);
  }

  @override
  HsbColor withChroma(double chroma) =>
      toOklabColor().withChroma(chroma).toHsbColor();

  /// Returns this [HsbColor] modified with the provided [alpha] value.
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
  RgbColor toRgbColor() => ColorConverter.hsbToRgb(this);

  @override
  HsbColor toHsbColor() => this;

  /// Returns a fixed-length list containing the [hue],
  /// [saturation], and [brightness] values, in that order.
  @override
  List<num> toList() =>
      List<num>.from(<num>[hue, saturation, brightness], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// [brightness], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[hue, saturation, brightness, alpha],
          growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [brightness] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        brightness / 100,
      ], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// [brightness], and [alpha] values factored to be on 0 to 1 scale.
  List<double> toFactoredListWithAlpha() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        brightness / 100,
        alpha / 255,
      ], growable: false);

  /// {@template color_models.HsbColor.from}
  ///
  /// Constructs a [HsbColor] from [color].
  ///
  /// {@endtemplate}
  factory HsbColor.from(ColorModel color) => color.toHsbColor();

  /// {@template color_models.HsbColor.fromList}
  ///
  /// Constructs a [HsbColor] from a list of [hsb] values.
  ///
  /// [hsb] must not be null and must have exactly `3` or `4` values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The [saturation] and [brightness] must both be `>= 0` and `<= 100`.
  ///
  /// The [alpha] value, if provided, must be `>= 0 && <= 255`.
  ///
  /// {@endtemplate}
  factory HsbColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return HsbColor(values[0], values[1], values[2], alpha);
  }

  /// {@template color_models.HsbColor.fromHex}
  ///
  /// Constructs a [HsbColor] from a RGB [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  ///
  /// {@endtemplate}
  factory HsbColor.fromHex(String hex) =>
      ColorConverter.hexToRgb(hex).toHsbColor();

  /// {@template color_models.HsbColor.extrapolate}
  ///
  /// Constructs a [HsbColor] from a list of [hsb] values on a `0` to `1` scale.
  ///
  /// [hsb] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  ///
  /// {@endtemplate}
  factory HsbColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HsbColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// {@template color_models.HsbColor.random}
  ///
  /// Generates a [HsbColor] at random.
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
  /// [minBrightness] and [maxBrightness] constrain the generated [brightness] value.
  ///
  /// Min and max values, besides hues, must be `min <= max && max >= min`,
  /// must be in the range of `>= 0 && <= 100`, and must not be `null`.
  ///
  /// {@endtemplate}
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
    return HsbColor(
      ColorMath.randomHue(minHue, maxHue, seed),
      ColorMath.random(minSaturation, maxSaturation, seed),
      ColorMath.random(minBrightness, maxBrightness, seed),
    );
  }

  @override
  HsbColor convert(ColorModel other) => other.toHsbColor();

  @override
  String toString() => 'HsbColor($hue, $saturation, $brightness, $alpha)';

  @override
  bool operator ==(Object other) =>
      other is HsbColor &&
      ColorMath.round(hue) == ColorMath.round(other.hue) &&
      ColorMath.round(saturation) == ColorMath.round(other.saturation) &&
      ColorMath.round(brightness) == ColorMath.round(other.brightness) &&
      alpha == other.alpha;

  @override
  int get hashCode =>
      hue.hashCode ^ saturation.hashCode ^ brightness.hashCode ^ alpha.hashCode;
}
