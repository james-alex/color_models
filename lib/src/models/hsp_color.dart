import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';

/// A color in the HSP color space.
///
/// The HSP color space contains channels for [hue],
/// [saturation], and [perceivedBrightness].
///
/// The HSP color space was created in 2006 by Darel Rex Finley.
/// Read about it here: http://alienryderflex.com/hsp.html
@immutable
class HspColor extends ColorModel {
  /// A color in the HSP color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [perceivedBrightness] must both be `>= 0` and `<= 100`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  const HspColor(
    this.hue,
    this.saturation,
    this.perceivedBrightness, [
    this.alpha = 1.0,
  ])  : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(perceivedBrightness != null &&
            perceivedBrightness >= 0 &&
            perceivedBrightness <= 100),
        assert(alpha != null && alpha >= 0 && alpha <= 1);

  /// The hue value of this color.
  ///
  /// Ranges from `0` to `360`.
  @override
  final num hue;

  /// The saturation value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num saturation;

  /// Thie perceived brightness value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num perceivedBrightness;

  @override
  final num alpha;

  @override
  bool get isBlack => (perceivedBrightness == 0);

  @override
  bool get isWhite => (perceivedBrightness == 1);

  /// Adjusts this colors [hue] by `180` degrees while inverting the
  /// [saturation] and [perceivedBrightness] values.
  @override
  HspColor get inverted => HspColor(
      (hue + 180) % 360, 100 - saturation, 100 - perceivedBrightness, alpha);

  @override
  HspColor get opposite => rotateHue(180);

  @override
  HspColor rotateHue(num amount) {
    assert(amount != null);

    return withHue((hue + amount) % 360);
  }

  @override
  HspColor warmer(num amount) {
    assert(amount != null && amount > 0);

    return withHue(ColorAdjustments.warmerHue(hue, amount));
  }

  @override
  HspColor cooler(num amount) {
    assert(amount != null && amount > 0);

    return withHue(ColorAdjustments.coolerHue(hue, amount));
  }

  /// Returns this [HspColor] modified with the provided [hue] value.
  HspColor withHue(num hue) {
    assert(hue != null && hue >= 0 && hue <= 360);

    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  /// Returns this [HspColor] modified with the provided [saturation] value.
  HspColor withSaturation(num saturation) {
    assert(saturation != null && saturation >= 0 && saturation <= 100);

    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  /// Returns this [HspColor] modified with the provided [saturation] value.
  HspColor withPerceivedBrightness(num perceivedBrightness) {
    assert(perceivedBrightness != null &&
        perceivedBrightness >= 0 &&
        perceivedBrightness <= 100);

    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  /// Returns this [HspColor] modified with the provided [alpha] value.
  @override
  HspColor withAlpha(num alpha) {
    assert(alpha != null && alpha >= 0 && alpha <= 1);

    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  @override
  RgbColor toRgbColor() => ColorConverter.hspToRgb(this);

  /// Returns a fixed-length [List] containing the [hue], [saturation],
  /// and [perceivedBrightness] values, in that order.
  @override
  List<num> toList() =>
      List<num>.from(<num>[hue, saturation, perceivedBrightness],
          growable: false);

  /// Returns a fixed-length [List] containing the [hue], [saturation],
  /// [perceivedBrightness], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[hue, saturation, perceivedBrightness, alpha],
          growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [perceivedBrightness] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        perceivedBrightness / 100,
      ], growable: false);

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// [perceivedBrightness], and [alpha] values factored to be on 0 to 1 scale.
  List<double> toFactoredListWithAlpha() => List<double>.from(<double>[
        hue / 360,
        saturation / 100,
        perceivedBrightness / 100,
        alpha,
      ], growable: false);

  /// Constructs a [HspColor] from [color].
  factory HspColor.from(ColorModel color) {
    assert(color != null);

    return color.toHspColor();
  }

  /// Constructs a [HspColor] from a list of [hsp] values.
  ///
  /// [hsp] must not be null and must have exactly `3` or `4` values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and perceived brightness must both be `>= 0` and `<= 100`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 1`.
  factory HspColor.fromList(List<num> hsp) {
    assert(hsp != null && (hsp.length == 3 || hsp.length == 4));
    assert(hsp[0] != null && hsp[0] >= 0 && hsp[0] <= 360);
    assert(hsp[1] != null && hsp[1] >= 0 && hsp[1] <= 100);
    assert(hsp[2] != null && hsp[2] >= 0 && hsp[2] <= 100);
    if (hsp.length == 4) {
      assert(hsp[3] != null && hsp[3] >= 0 && hsp[3] <= 1);
    }

    final alpha = hsp.length == 4 ? hsp[3] : 1.0;

    return HspColor(hsp[0], hsp[1], hsp[2], alpha);
  }

  /// Constructs a [HspColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory HspColor.fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toHspColor();
  }

  /// Constructs a [HspColor] from a list of [hsp] values on a `0` to `1` scale.
  ///
  /// [hsp] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory HspColor.extrapolate(List<double> hsp) {
    assert(hsp != null && (hsp.length == 3 || hsp.length == 4));
    assert(hsp[0] != null && hsp[0] >= 0 && hsp[0] <= 1);
    assert(hsp[1] != null && hsp[1] >= 0 && hsp[1] <= 1);
    assert(hsp[2] != null && hsp[2] >= 0 && hsp[2] <= 1);
    if (hsp.length == 4) {
      assert(hsp[3] != null && hsp[3] >= 0 && hsp[3] <= 1);
    }

    final alpha = hsp.length == 4 ? hsp[3] : 1.0;

    return HspColor(hsp[0] * 360, hsp[1] * 100, hsp[2] * 100, alpha);
  }

  @override
  String toString() =>
      'HspColor($hue, $saturation, $perceivedBrightness, $alpha)';

  @override
  bool operator ==(Object o) =>
      o is HspColor &&
      hue == o.hue &&
      saturation == o.saturation &&
      perceivedBrightness == o.perceivedBrightness &&
      alpha == o.alpha;

  @override
  int get hashCode =>
      hue.hashCode ^
      saturation.hashCode ^
      perceivedBrightness.hashCode ^
      alpha.hashCode;
}
