import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';

/// A color in the HSI color space.
///
/// The HSI color space contains channels for [hue],
/// [saturation], and [intensity].
@immutable
class HsiColor extends ColorModel {
  /// A color in the HSV (HSB) color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [intensity] must both be `>= 0` and `<= 100`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  const HsiColor(
    this.hue,
    this.saturation,
    this.intensity, [
    this.alpha = 1.0,
  ])  : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(intensity != null && intensity >= 0 && intensity <= 100),
        assert(alpha != null && alpha >= 0 && alpha <= 1);

  /// The hue value of this color.
  ///
  /// Ranges from `0` to `360`.
  final num hue;

  /// The saturation value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num saturation;

  /// The intensity value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num intensity;

  @override
  final num alpha;

  @override
  bool get isBlack => (intensity == 0);

  @override
  bool get isWhite => (saturation == 0 && intensity == 100);

  /// Adjusts this colors [hue] by `180` degrees while inverting the
  /// [saturation] and [intensity] values.
  @override
  HsiColor get inverted =>
      HsiColor((hue + 180) % 360, 100 - saturation, 100 - intensity, alpha);

  @override
  HsiColor get opposite => rotateHue(180);

  @override
  HsiColor rotateHue(num amount) {
    assert(amount != null);

    return withHue((hue + amount) % 360);
  }

  @override
  HsiColor warmer(num amount) {
    assert(amount != null && amount > 0);

    return withHue(ColorAdjustments.warmerHue(hue, amount));
  }

  @override
  HsiColor cooler(num amount) {
    assert(amount != null && amount > 0);

    return withHue(ColorAdjustments.coolerHue(hue, amount));
  }

  /// Returns this [HsiColor] modified with the provided [hue] value.
  HsiColor withHue(num hue) {
    assert(hue != null && hue >= 0 && hue <= 360);

    return HsiColor(hue, saturation, intensity, alpha);
  }

  /// Returns this [HsiColor] modified with the provided [saturation] value.
  HsiColor withSaturation(num saturation) {
    assert(saturation != null && saturation >= 0 && saturation <= 100);

    return HsiColor(hue, saturation, intensity, alpha);
  }

  /// Returns this [HsiColor] modified with the provided [intensity] value.
  HsiColor withIntensity(num intensity) {
    assert(intensity != null && intensity >= 0 && intensity <= 100);

    return HsiColor(hue, saturation, intensity, alpha);
  }

  /// Returns this [HsiColor] modified with the provided [alpha] value.
  @override
  HsiColor withAlpha(num alpha) {
    assert(alpha != null && alpha >= 0 && alpha <= 1);

    return HsiColor(hue, saturation, intensity, alpha);
  }

  @override
  RgbColor toRgbColor() => ColorConverter.hsiToRgb(this);

  /// Returns a fixed-length [List] containing the [hue],
  /// [saturation], and [intensity] values, in that order.
  @override
  List<num> toList() =>
      List<num>.from(<num>[hue, saturation, intensity], growable: false);

  /// Returns a fixed-length [List] containing the [hue], [saturation],
  /// [intensity], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[hue, saturation, intensity, alpha], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [intensity] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        intensity / 100,
      ], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// [intensity], and [alpha] values factored to be on 0 to 1 scale.
  List<double> toFactoredListWithAlpha() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        intensity / 100,
        alpha,
      ], growable: false);

  /// Constructs a [HsiColor] from [color].
  factory HsiColor.from(ColorModel color) {
    assert(color != null);

    return color.toHsiColor();
  }

  /// Constructs a [HsiColor] from a list of [hsi] values.
  ///
  /// [hsi] must not be null and must have exactly `3` or `4` values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and intensity must both be `>= 0` and `<= 100`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 1`.
  factory HsiColor.fromList(List<num> hsi) {
    assert(hsi != null && (hsi.length == 3 || hsi.length == 4));
    assert(hsi[0] != null && hsi[0] >= 0 && hsi[0] <= 360);
    assert(hsi[1] != null && hsi[1] >= 0 && hsi[1] <= 100);
    assert(hsi[2] != null && hsi[2] >= 0 && hsi[2] <= 100);
    if (hsi.length == 4) {
      assert(hsi[3] != null && hsi[3] >= 0 && hsi[3] <= 1);
    }

    final alpha = hsi.length == 4 ? hsi[3] : 1.0;

    return HsiColor(hsi[0], hsi[1], hsi[2], alpha);
  }

  /// Constructs a [HsiColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory HsiColor.fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toHsiColor();
  }

  /// Constructs a [HsiColor] from a list of [hsi] values on a `0` to `1` scale.
  ///
  /// [hsi] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory HsiColor.extrapolate(List<double> hsi) {
    assert(hsi != null && (hsi.length == 3 || hsi.length == 4));
    assert(hsi[0] != null && hsi[0] >= 0 && hsi[0] <= 1);
    assert(hsi[1] != null && hsi[1] >= 0 && hsi[1] <= 1);
    assert(hsi[2] != null && hsi[2] >= 0 && hsi[2] <= 1);
    if (hsi.length == 4) {
      assert(hsi[3] != null && hsi[3] >= 0 && hsi[3] <= 1);
    }

    final alpha = hsi.length == 4 ? hsi[3] : 1.0;

    return HsiColor(hsi[0] * 360, hsi[1] * 100, hsi[2] * 100, alpha);
  }

  @override
  String toString() => 'HsiColor($hue, $saturation, $intensity, $alpha)';

  @override
  bool operator ==(Object o) =>
      o is HsiColor &&
      hue == o.hue &&
      saturation == o.saturation &&
      intensity == o.intensity &&
      alpha == o.alpha;

  @override
  int get hashCode =>
      hue.hashCode ^ saturation.hashCode ^ intensity.hashCode ^ alpha.hashCode;
}
