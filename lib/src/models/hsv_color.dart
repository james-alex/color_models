import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';

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
    this.alpha = 1.0,
  ])  : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(value != null && value >= 0 && value <= 100),
        assert(alpha != null && alpha >= 0 && alpha <= 1);

  /// The hue value of this color.
  ///
  /// Ranges from `0` to `360`.
  final num hue;

  /// The saturation value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num saturation;

  /// The value (brightness) value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num value;

  @override
  final num alpha;

  @override
  bool get isBlack => (value == 0);

  @override
  bool get isWhite => (saturation == 0 && value == 1);

  /// Adjusts this colors [hue] by `180` degrees while inverting the
  /// [saturation] and [value] values.
  @override
  HsvColor get inverted =>
      HsvColor((hue + 180) % 360, 100 - saturation, 100 - value, alpha);

  @override
  HsvColor rotateHue(num amount) {
    assert(amount != null);

    return withHue((hue + amount) % 360);
  }

  @override
  HsvColor warmer(num amount) {
    assert(amount != null && amount > 0);

    return withHue(ColorAdjustments.warmerHue(hue, amount));
  }

  @override
  HsvColor cooler(num amount) {
    assert(amount != null && amount > 0);

    return withHue(ColorAdjustments.coolerHue(hue, amount));
  }

  /// Returns this [HsvColor] modified with the provided [hue] value.
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
    assert(alpha != null && alpha >= 0 && alpha <= 1);

    return HsvColor(hue, saturation, value, alpha);
  }

  @override
  RgbColor toRgbColor() => ColorConverter.hsvToRgb(this);

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
        alpha,
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
  /// The [alpha] value, if included, must be `>= 0 && <= 1`.
  factory HsvColor.fromList(List<num> hsv) {
    assert(hsv != null && (hsv.length == 3 || hsv.length == 4));
    assert(hsv[0] != null && hsv[0] >= 0 && hsv[0] <= 360);
    assert(hsv[1] != null && hsv[1] >= 0 && hsv[1] <= 100);
    assert(hsv[2] != null && hsv[2] >= 0 && hsv[2] <= 100);
    if (hsv.length == 4) {
      assert(hsv[3] != null && hsv[3] >= 0 && hsv[3] <= 1);
    }

    final alpha = hsv.length == 4 ? hsv[3] : 1.0;

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

    final alpha = hsv.length == 4 ? hsv[3] : 1.0;

    return HsvColor(hsv[0] * 360, hsv[1] * 100, hsv[2] * 100, alpha);
  }

  @override
  String toString() => 'HsvColor($hue, $saturation, $value, $alpha)';

  @override
  bool operator ==(Object o) =>
      o is HsvColor &&
      hue == o.hue &&
      saturation == o.saturation &&
      value == o.value &&
      alpha == o.alpha;

  @override
  int get hashCode =>
      hue.hashCode ^ saturation.hashCode ^ value.hashCode ^ alpha.hashCode;
}
