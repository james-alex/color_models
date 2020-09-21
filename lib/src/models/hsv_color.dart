import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';
import '../helpers/random.dart';
import '../helpers/round_values.dart';

/// A color in the HSV (HSB) color space.
///
/// The HSV color space contains channels for [hue],
/// [saturation], and [value].
@immutable
class HsvColor extends ColorModel {
  /// A color in the HSV (HSB) color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [value] must both be `>= 0` and `<= 100`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  const HsvColor(
    this.hue,
    this.saturation,
    this.value, [
    int alpha = 255,
  ])  : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(value != null && value >= 0 && value <= 100),
        assert(alpha != null && alpha >= 0 && alpha <= 255),
        super(alpha);

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

  /// The value (brightness) value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num value;

  @override
  bool get isBlack => round(value) == 0;

  @override
  bool get isWhite => round(saturation) == 0 && round(value) == 1;

  @override
  bool get isMonochromatic => round(value) == 0 || round(saturation) == 0;

  @override
  List<HsvColor> interpolateTo(
    ColorModel color,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(color != null);
    assert(steps != null && steps > 0);
    assert(excludeOriginalColors != null);

    if (color.runtimeType != HsvColor) {
      color = color.toHsvColor();
    }

    return List<HsvColor>.from(
      ColorAdjustments.interpolateColors(
        this,
        color,
        steps,
        excludeOriginalColors: excludeOriginalColors,
      ),
    );
  }

  /// Adjusts this colors [hue] by `180` degrees while inverting the
  /// [saturation] and [value] values.
  @override
  HsvColor get inverted =>
      HsvColor((hue + 180) % 360, 100 - saturation, 100 - value, alpha);

  @override
  HsvColor get opposite => rotateHue(180);

  @override
  HsvColor rotateHue(num amount) {
    assert(amount != null);

    return withHue((hue + amount) % 360);
  }

  @override
  HsvColor warmer(num amount, {bool relative = true}) {
    assert(amount != null && amount > 0);
    assert(relative != null);
    if (relative) assert(amount <= 100);

    return withHue(ColorAdjustments.warmerHue(hue, amount, relative: relative));
  }

  @override
  HsvColor cooler(num amount, {bool relative = true}) {
    assert(amount != null && amount > 0);
    assert(relative != null);
    if (relative) assert(amount <= 100);

    return withHue(ColorAdjustments.coolerHue(hue, amount, relative: relative));
  }

  /// Returns this [HsvColor] modified with the provided [hue] value.
  @override
  HsvColor withHue(num hue) {
    assert(hue != null && hue >= 0 && hue <= 360);

    return HsvColor(hue, saturation, value, alpha);
  }

  /// Returns this [HsvColor] modified with the provided [saturation] value.
  HsvColor withSaturation(num saturation) {
    assert(saturation != null && saturation >= 0 && saturation <= 100);

    return HsvColor(hue, saturation, value, alpha);
  }

  /// Returns this [HsvColor] modified with the provided [value] value.
  HsvColor withValue(num value) {
    assert(value != null && value >= 0 && value <= 100);

    return HsvColor(hue, saturation, value, alpha);
  }

  /// Returns this [HsvColor] modified with the provided [alpha] value.
  @override
  HsvColor withAlpha(num alpha) {
    assert(alpha != null && alpha >= 0 && alpha <= 255);

    return HsvColor(hue, saturation, value, alpha);
  }

  @override
  RgbColor toRgbColor() => ColorConverter.hsvToRgb(this);

  @override
  HsvColor toHsvColor() => this;

  /// Returns a fixed-length [List] containing the [hue],
  /// [saturation], and [value] values, in that order.
  @override
  List<num> toList() =>
      List<num>.from(<num>[hue, saturation, value], growable: false);

  /// Returns a fixed-length [List] containing the [hue], [saturation],
  /// [value], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[hue, saturation, value, alpha], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [value] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        value / 100,
      ], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// [value], and [alpha] values factored to be on 0 to 1 scale.
  List<double> toFactoredListWithAlpha() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        value / 100,
        alpha / 255,
      ], growable: false);

  /// Constructs a [HsvColor] from [color].
  factory HsvColor.from(ColorModel color) {
    assert(color != null);

    return color.toHsvColor();
  }

  /// Constructs a [HsvColor] from a list of [hsv] values.
  ///
  /// [hsv] must not be null and must have exactly `3` or `4` values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and value must both be `>= 0` and `<= 100`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 255`.
  factory HsvColor.fromList(List<num> hsv) {
    assert(hsv != null && (hsv.length == 3 || hsv.length == 4));
    assert(hsv[0] != null && hsv[0] >= 0 && hsv[0] <= 360);
    assert(hsv[1] != null && hsv[1] >= 0 && hsv[1] <= 100);
    assert(hsv[2] != null && hsv[2] >= 0 && hsv[2] <= 100);
    if (hsv.length == 4) {
      assert(hsv[3] != null && hsv[3] >= 0 && hsv[3] <= 255);
    }

    final alpha = hsv.length == 4 ? hsv[3].round() : 255;

    return HsvColor(hsv[0], hsv[1], hsv[2], alpha);
  }

  /// Constructs a [HsvColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory HsvColor.fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toHsvColor();
  }

  /// Constructs a [HsvColor] from a list of [hsv] values on a `0` to `1` scale.
  ///
  /// [hsv] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory HsvColor.extrapolate(List<double> hsv) {
    assert(hsv != null && (hsv.length == 3 || hsv.length == 4));
    assert(hsv[0] != null && hsv[0] >= 0 && hsv[0] <= 1);
    assert(hsv[1] != null && hsv[1] >= 0 && hsv[1] <= 1);
    assert(hsv[2] != null && hsv[2] >= 0 && hsv[2] <= 1);
    if (hsv.length == 4) {
      assert(hsv[3] != null && hsv[3] >= 0 && hsv[3] <= 1);
    }

    final alpha = hsv.length == 4 ? (hsv[3] * 255).round() : 255;

    return HsvColor(hsv[0] * 360, hsv[1] * 100, hsv[2] * 100, alpha);
  }

  /// Generates a [HsvColor] at random.
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
  /// [minValue] and [maxValue] constrain the generated [value] value.
  ///
  /// Min and max values, besides hues, must be `min <= max && max >= min`,
  /// must be in the range of `>= 0 && <= 100`, and must not be `null`.
  factory HsvColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minValue = 0,
    num maxValue = 100,
  }) {
    assert(minHue != null && minHue >= 0 && minHue <= 360);
    assert(maxHue != null && maxHue >= 0 && maxHue <= 360);
    assert(minSaturation != null &&
        minSaturation >= 0 &&
        minSaturation <= maxSaturation);
    assert(maxSaturation != null &&
        maxSaturation >= minSaturation &&
        maxSaturation <= 100);
    assert(minValue != null && minValue >= 0 && minValue <= maxValue);
    assert(maxValue != null && maxValue >= minValue && maxValue <= 100);

    return HsvColor(
      randomHue(minHue, maxHue),
      random(minSaturation, maxSaturation),
      random(minValue, maxValue),
    );
  }

  @override
  String toString() => 'HsvColor($hue, $saturation, $value, $alpha)';

  @override
  bool operator ==(Object o) =>
      o is HsvColor &&
      round(hue) == round(o.hue) &&
      round(saturation) == round(o.saturation) &&
      round(value) == round(o.value) &&
      alpha == o.alpha;

  @override
  int get hashCode =>
      hue.hashCode ^ saturation.hashCode ^ value.hashCode ^ alpha.hashCode;
}
