import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';

/// A color in the HSL color space.
///
/// The HSL color space contains channels for [hue],
/// [saturation], and [lightness].
@immutable
class HslColor extends ColorModel {
  /// A color in the HSL color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [lightness] must both be `>= 0` and `<= 100`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  const HslColor(
    this.hue,
    this.saturation,
    this.lightness, [
    this.alpha = 1.0,
  ])  : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(lightness != null && lightness >= 0 && lightness <= 100),
        assert(alpha != null && alpha >= 0 && alpha <= 1);

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

  /// The lightness value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num lightness;

  @override
  final num alpha;

  @override
  bool get isBlack => (lightness == 0);

  @override
  bool get isWhite => (lightness == 100);

  /// Adjusts this colors [hue] by `180` degrees while inverting the
  /// [saturation] and [lightness] values.
  @override
  HslColor get inverted =>
      HslColor((hue + 180) % 360, 100 - saturation, 100 - lightness, alpha);

  @override
  HslColor get opposite => rotateHue(180);

  @override
  HslColor rotateHue(num amount) {
    assert(amount != null);

    return withHue((hue + amount) % 360);
  }

  @override
  HslColor warmer(num amount) {
    assert(amount != null && amount > 0);

    return withHue(ColorAdjustments.warmerHue(hue, amount));
  }

  @override
  HslColor cooler(num amount) {
    assert(amount != null && amount > 0);

    return withHue(ColorAdjustments.coolerHue(hue, amount));
  }

  /// Returns this [HslColor] modified with the provided [hue] value.
  HslColor withHue(num hue) {
    assert(hue != null && hue >= 0 && hue <= 360);

    return HslColor(hue, saturation, lightness, alpha);
  }

  /// Returns this [HslColor] modified with the provided [saturation] value.
  HslColor withSaturation(num saturation) {
    assert(saturation != null && saturation >= 0 && saturation <= 100);

    return HslColor(hue, saturation, lightness, alpha);
  }

  /// Returns this [HslColor] modified with the provided [lightness] value.
  HslColor withLightness(num lightness) {
    assert(lightness != null && lightness >= 0 && lightness <= 100);

    return HslColor(hue, saturation, lightness, alpha);
  }

  /// Returns this [HslColor] modified with the provided [alpha] value.
  @override
  HslColor withAlpha(num alpha) {
    assert(alpha != null && alpha >= 0 && alpha <= 1);

    return HslColor(hue, saturation, lightness, alpha);
  }

  @override
  RgbColor toRgbColor() => ColorConverter.hslToRgb(this);

  /// Returns a fixed-length [List] containing the [hue],
  /// [saturation], and [lightness] values, in that order.
  @override
  List<num> toList() =>
      List<num>.from(<num>[hue, saturation, lightness], growable: false);

  /// Returns a fixed-length [List] containing the [hue], [saturation],
  /// [lightness], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[hue, saturation, lightness, alpha], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [lightness] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        lightness / 100,
      ], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// [lightness], and [alpha] values factored to be on 0 to 1 scale.
  List<double> toFactoredListWithAlpha() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        lightness / 100,
        alpha,
      ], growable: false);

  /// Constructs a [HslColor] from [color].
  factory HslColor.from(ColorModel color) {
    assert(color != null);

    return color.toHslColor();
  }

  /// Constructs a [HslColor] from a list of [hsl] values.
  ///
  /// [hsl] must not be null and must have exactly `3` or `4` values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and lightness must both be `>= 0` and `<= 100`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 1`.
  factory HslColor.fromList(List<num> hsl) {
    assert(hsl != null && (hsl.length == 3 || hsl.length == 4));
    assert(hsl[0] != null && hsl[0] >= 0 && hsl[0] <= 360);
    assert(hsl[1] != null && hsl[1] >= 0 && hsl[1] <= 100);
    assert(hsl[2] != null && hsl[2] >= 0 && hsl[2] <= 100);
    if (hsl.length == 4) {
      assert(hsl[3] != null && hsl[3] >= 0 && hsl[3] <= 1);
    }

    final alpha = hsl.length == 4 ? hsl[3] : 1.0;

    return HslColor(hsl[0], hsl[1], hsl[2], alpha);
  }

  /// Constructs a [HslColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory HslColor.fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toHslColor();
  }

  /// Constructs a [HslColor] from a list of [hsl] values on a `0` to `1` scale.
  ///
  /// [hsl] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory HslColor.extrapolate(List<double> hsl) {
    assert(hsl != null && (hsl.length == 3 || hsl.length == 4));
    assert(hsl[0] != null && hsl[0] >= 0 && hsl[0] <= 1);
    assert(hsl[1] != null && hsl[1] >= 0 && hsl[1] <= 1);
    assert(hsl[2] != null && hsl[2] >= 0 && hsl[2] <= 1);
    if (hsl.length == 4) {
      assert(hsl[3] != null && hsl[3] >= 0 && hsl[3] <= 1);
    }

    final alpha = hsl.length == 4 ? hsl[3] : 1.0;

    return HslColor(hsl[0] * 360, hsl[1] * 100, hsl[2] * 100, alpha);
  }

  @override
  String toString() => 'HslColor($hue, $saturation, $lightness, $alpha)';

  @override
  bool operator ==(Object o) =>
      o is HslColor &&
      hue == o.hue &&
      saturation == o.saturation &&
      lightness == o.lightness &&
      alpha == o.alpha;

  @override
  int get hashCode =>
      hue.hashCode ^ saturation.hashCode ^ lightness.hashCode ^ alpha.hashCode;
}
