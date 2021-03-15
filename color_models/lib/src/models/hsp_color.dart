import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';
import '../helpers/color_math.dart';

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
    int alpha = 255,
  ])  : assert(hue >= 0 && hue <= 360),
        assert(saturation >= 0 && saturation <= 100),
        assert(perceivedBrightness >= 0 && perceivedBrightness <= 100),
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

  /// Thie perceived brightness value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num perceivedBrightness;

  @override
  bool get isBlack => ColorMath.round(perceivedBrightness) == 0;

  @override
  bool get isWhite =>
      ColorMath.round(saturation) == 0 &&
      ColorMath.round(perceivedBrightness) == 1;

  @override
  bool get isMonochromatic {
    final perceivedBrightness = ColorMath.round(this.perceivedBrightness);
    return perceivedBrightness == 0 || ColorMath.round(saturation) == 0;
  }

  @override
  HspColor interpolate(ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step) as HspColor;
  }

  @override
  List<HspColor> lerpTo(
    ColorModel color,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps, excludeOriginalColors: excludeOriginalColors)
        .cast<HspColor>();
  }

  /// Adjusts this colors [hue] by `180` degrees while inverting the
  /// [saturation] and [perceivedBrightness] values.
  @override
  HspColor get inverted => HspColor(
      (hue + 180) % 360, 100 - saturation, 100 - perceivedBrightness, alpha);

  @override
  HspColor get opposite => rotateHue(180);

  @override
  HspColor rotateHue(num amount) => withHue((hue + amount) % 360);

  @override
  HspColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    if (relative) assert(amount <= 100);
    return withHue(ColorAdjustments.warmerHue(hue, amount, relative: relative));
  }

  @override
  HspColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    if (relative) assert(amount <= 100);
    return withHue(ColorAdjustments.coolerHue(hue, amount, relative: relative));
  }

  /// Returns this [HspColor] modified with the provided [hue] value.
  @override
  HspColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  /// Returns this [HspColor] modified with the provided [saturation] value.
  HspColor withSaturation(num saturation) {
    assert(saturation >= 0 && saturation <= 100);
    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  /// Returns this [HspColor] modified with the provided [saturation] value.
  HspColor withPerceivedBrightness(num perceivedBrightness) {
    assert(perceivedBrightness >= 0 && perceivedBrightness <= 100);
    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  /// Returns this [HspColor] modified with the provided [alpha] value.
  @override
  HspColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return HspColor(hue, saturation, perceivedBrightness, alpha);
  }

  @override
  HspColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((opacity * 255).round());
  }

  @override
  RgbColor toRgbColor() => ColorConverter.hspToRgb(this);

  @override
  HspColor toHspColor() => this;

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
        alpha / 255,
      ], growable: false);

  /// Constructs a [HspColor] from [color].
  factory HspColor.from(ColorModel color) => color.toHspColor();

  /// Constructs a [HspColor] from a list of [hsp] values.
  ///
  /// [hsp] must not be null and must have exactly `3` or `4` values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and perceived brightness must both be `>= 0` and `<= 100`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 255`.
  factory HspColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return HspColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [HspColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory HspColor.fromHex(String hex) =>
      ColorConverter.hexToRgb(hex).toHspColor();

  /// Constructs a [HspColor] from a list of [hsp] values on a `0` to `1` scale.
  ///
  /// [hsp] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory HspColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HspColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// Generates a [HspColor] at random.
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
  /// [minPerceivedBrightness] and [maxPerceivedBrightness] constrain the
  /// generated [perceivedBrightness] value.
  ///
  /// Min and max values, besides hues, must be `min <= max && max >= min`,
  /// must be in the range of `>= 0 && <= 100`, and must not be `null`.
  factory HspColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minPerceivedBrightness = 0,
    num maxPerceivedBrightness = 100,
  }) {
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minPerceivedBrightness >= 0 &&
        minPerceivedBrightness <= maxPerceivedBrightness);
    assert(maxPerceivedBrightness >= minPerceivedBrightness &&
        maxPerceivedBrightness <= 100);
    return HspColor(
      ColorMath.randomHue(minHue, maxHue),
      ColorMath.random(minSaturation, maxSaturation),
      ColorMath.random(minPerceivedBrightness, maxPerceivedBrightness),
    );
  }

  @override
  HspColor convert(ColorModel other) => other.toHspColor();

  @override
  String toString() =>
      'HspColor($hue, $saturation, $perceivedBrightness, $alpha)';

  @override
  bool operator ==(Object other) =>
      other is HspColor &&
      ColorMath.round(hue) == ColorMath.round(other.hue) &&
      ColorMath.round(saturation) == ColorMath.round(other.saturation) &&
      ColorMath.round(perceivedBrightness) ==
          ColorMath.round(other.perceivedBrightness) &&
      alpha == other.alpha;

  @override
  int get hashCode =>
      hue.hashCode ^
      saturation.hashCode ^
      perceivedBrightness.hashCode ^
      alpha.hashCode;
}
