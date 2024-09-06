import 'dart:math' as math;
import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';
import '../helpers/color_math.dart';

/// {@template color_models.OklabColor}
///
/// A color in the Oklab color space.
///
/// The Oklab color space contains channels for [lightness],
/// [lab_a] (red and green opponent values), and [lab_b] (blue and
/// yellow opponent values.)
///
/// __See:__ https://bottosson.github.io/posts/oklab/
///
/// {@endtemplate}
@immutable
class OklabColor extends ColorModel {
  /// {@template color_models.OklabColor.constructor}
  ///
  /// A color in the Oklab color space.
  ///
  /// [lightness], [lab_a], and [lab_b]'s normal range is `0.0` to `1.0`,
  /// but some colors may fall slightly outside of it.
  ///
  /// [alpha] must be `>= 0` and `<= 255`.
  ///
  /// __See:__ https://bottosson.github.io/posts/oklab/
  ///
  /// {@endtemplate}
  const OklabColor(
    this.lightness,
    this.lab_a,
    this.lab_b, [
    int alpha = 255,
  ])  : assert(alpha >= 0 && alpha <= 255),
        super(alpha: alpha);

  /// Lightness represents the black to white value.
  ///
  /// The value ranges from black at `0.0` to white at `1.0`.
  final double lightness;

  /// The red to green opponent color value.
  ///
  /// The value ranges from red at `0.0` to green at `1.0`.
  final double lab_a;

  /// The yellow to blue opponent color value.
  ///
  /// The value ranges from yellow at `0.0` to blue at `1.0`.
  final double lab_b;

  @override
  bool get isBlack =>
      ColorMath.round(lightness) <= 0 &&
      ColorMath.round(lab_a) <= 0 &&
      ColorMath.round(lab_b) <= 0;

  @override
  bool get isWhite =>
      ColorMath.round(lightness) >= 1 &&
      ColorMath.round(lab_a) <= 0 &&
      ColorMath.round(lab_b) <= 0;

  @override
  bool get isMonochromatic =>
      ColorMath.round(lab_a) == 0 && ColorMath.round(lab_b) == 0;

  @override
  OklabColor interpolate(ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step) as OklabColor;
  }

  @override
  List<OklabColor> lerpTo(
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
        .cast<OklabColor>();
  }

  @override
  OklabColor get inverted =>
      OklabColor(1.0 - lightness, 1.0 - lab_a, 1.0 - lab_b, alpha);

  @override
  OklabColor get opposite => rotateHue(180);

  @override
  OklabColor rotateHue(num amount) =>
      ColorAdjustments.rotateHue(this, amount).toOklabColor();

  @override
  OklabColor rotateHueRad(double amount) =>
      ColorAdjustments.rotateHueRad(this, amount).toOklabColor();

  @override
  OklabColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return ColorAdjustments.warmer(this, amount, relative: relative)
        .toOklabColor();
  }

  @override
  OklabColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return ColorAdjustments.cooler(this, amount, relative: relative)
        .toOklabColor();
  }

  /// Returns this [OklabColor] modified with the provided [hue] value.
  @override
  OklabColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toOklabColor();
  }

  @override
  OklabColor withChroma(double chroma) {
    assert(chroma >= 0.0 && chroma <= 1.0);
    final lightness =
        chroma == 0 ? 0.0 : (1.028 * math.pow(chroma, 1 / 6.9)) - 0.028;
    return copyWith(lightness: lightness);
  }

  /// Returns this [OklabColor] modified with the provided [alpha] value.
  @override
  OklabColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return OklabColor(lightness, lab_a, lab_b, alpha);
  }

  @override
  OklabColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  OklabColor withValuesList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return OklabColor.fromList(values);
  }

  @override
  OklabColor copyWith({
    double? lightness,
    double? a,
    double? b,
    int? alpha,
  }) {
    assert(lightness == null || (lightness >= 0 && lightness <= 1.0));
    assert(a == null || (a >= 0 && a <= 1.0));
    assert(b == null || (b >= 0 && b <= 1.0));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return OklabColor(
      lightness ?? this.lightness,
      a ?? this.lab_a,
      b ?? this.lab_b,
      alpha ?? this.alpha,
    );
  }

  @override
  RgbColor toRgbColor() => ColorConverter.oklabToRgb(this);

  @override
  OklabColor toOklabColor() => this;

  /// Returns a fixed-length list containing the [lightness],
  /// [lab_a], and [lab_b] values, in that order.
  @override
  List<double> toList() =>
      List<double>.from(<double>[lightness, lab_a, lab_b], growable: false);

  /// Returns a fixed-length list containing the [lightness],
  /// [lab_a], [lab_b], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[lightness, lab_a, lab_b, alpha], growable: false);

  /// {@template color_models.OklabColor.from}
  ///
  /// Constructs an [OklabColor] from [color].
  ///
  /// {@endtemplate}
  factory OklabColor.from(ColorModel color) => color.toOklabColor();

  /// {@template color_models.OklabColor.fromList}
  ///
  /// Constructs an [OklabColor] from a list of [lab] values.
  ///
  /// [lab] must have exactly `3` or `4` values.
  ///
  /// The [alpha] value, if provided, must be `>= 0 && <= 255`.
  ///
  /// {@endtemplate}
  factory OklabColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return OklabColor(values[0].toDouble(), values[1].toDouble(),
        values[2].toDouble(), alpha);
  }

  /// {@template color_models.OklabColor.fromHex}
  ///
  /// Constructs an [OklabColor] from a RGB [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  ///
  /// {@endtemplate}
  factory OklabColor.fromHex(String hex) =>
      ColorConverter.hexToRgb(hex).toOklabColor();

  /// {@template color_models.OklabColor.random}
  ///
  /// Generates an [OklabColor] at random.
  ///
  /// [minLightness] and [maxLightness] constrain the generated
  /// [lightness] value.
  ///
  /// [minA] and [maxA] constrain the generated [lab_a] value.
  ///
  /// [minB] and [maxB] constrain the generated [lab_b] value.
  ///
  /// All min and max values must be `min <= max && max >= min`, must
  /// be in the range of `>= 0.0 && <= 1.0`, and must not be `null`.
  ///
  /// {@endtemplate}
  factory OklabColor.random({
    double minLightness = 0.0,
    double maxLightness = 1.0,
    double minA = 0.0,
    double maxA = 1.0,
    double minB = 0.0,
    double maxB = 1.0,
    int? seed,
  }) {
    return OklabColor(
      ColorMath.random(minLightness, maxLightness, seed),
      ColorMath.random(minA, maxA, seed),
      ColorMath.random(minB, maxB, seed),
    );
  }

  @override
  OklabColor convert(ColorModel other) => other.toOklabColor();

  @override
  String toString() => 'OklabColor($lightness, $lab_a, $lab_b, $alpha)';

  @override
  bool operator ==(Object other) =>
      other is OklabColor &&
      ColorMath.round(lightness) == ColorMath.round(other.lightness) &&
      ColorMath.round(lab_a) == ColorMath.round(other.lab_a) &&
      ColorMath.round(lab_b) == ColorMath.round(other.lab_b) &&
      alpha == other.alpha;

  @override
  int get hashCode =>
      lightness.hashCode ^ lab_a.hashCode ^ lab_b.hashCode ^ alpha.hashCode;
}
