import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';

/// A color in the CIELAB color space.
///
/// The CIELAB color space contains channels for [lightness],
/// [a] (red and green opponent values), and [b] (blue and
/// yellow opponent values.)
@immutable
class LabColor extends ColorModel {
  /// A color in the CIELAB color space.
  ///
  /// [lightness] must be `>= 0` and `<= 100`.
  ///
  /// [a] and [b] must both be `>= -128` and `<= 127`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  const LabColor(
    this.lightness,
    this.a,
    this.b, [
    this.alpha = 1.0,
  ])  : assert(lightness != null && lightness >= 0 && lightness <= 100),
        assert(a != null && a >= -128 && a <= 127),
        assert(b != null && b >= -128 && b <= 127),
        assert(alpha != null && alpha >= 0 && alpha <= 1);

  /// Lightness represents the black to white value.
  ///
  /// The value ranges from black at `0` to white at `100`.
  final num lightness;

  /// The red to green opponent color value.
  ///
  /// Green is represented in the negative value range (`-128` to `0`)
  ///
  /// Red is represented in the positive value range (`0` to `127`)
  final num a;

  /// The yellow to blue opponent color value.
  ///
  /// Yellow is represented int he negative value range (`-128` to `0`)
  ///
  /// Blue is represented in the positive value range (`0` to `127`)
  final num b;

  @override
  final num alpha;

  @override
  bool get isBlack => (lightness == 0 && a == 0 && b == 0);

  @override
  bool get isWhite => (lightness == 1 && a == 0 && b == 0);

  @override
  LabColor get inverted => LabColor(
      100 - lightness, 255 - (a + 128) - 128, 255 - (b + 128) - 128, alpha);

  @override
  LabColor get opposite => rotateHue(180);

  @override
  LabColor rotateHue(num amount) {
    assert(amount != null);

    return ColorAdjustments.rotateHue(this, amount).toLabColor();
  }

  @override
  LabColor warmer(num amount) {
    assert(amount != null && amount > 0);

    return ColorAdjustments.warmer(this, amount).toLabColor();
  }

  @override
  LabColor cooler(num amount) {
    assert(amount != null && amount > 0);

    return ColorAdjustments.cooler(this, amount).toLabColor();
  }

  /// Returns this [LabColor] modified with the provided [lightness] value.
  LabColor withLightness(num lightness) {
    assert(lightness != null && lightness >= 0 && lightness <= 100);

    return LabColor(lightness, a, b, alpha);
  }

  /// Returns this [LabColor] modified with the provided [a] value.
  LabColor withA(num a) {
    assert(a != null && a >= -128 && a <= 127);

    return LabColor(lightness, a, b, alpha);
  }

  /// Returns this [LabColor] modified with the provided [b] value.
  LabColor withB(num b) {
    assert(b != null && b >= -128 && b <= 127);

    return LabColor(lightness, a, b, alpha);
  }

  /// Returns this [LabColor] modified with the provided [alpha] value.
  @override
  LabColor withAlpha(num alpha) {
    assert(alpha != null && alpha >= 0 && alpha <= 1);

    return LabColor(lightness, a, b, alpha);
  }

  /// Returns this [LabColor] modified with the provided [hue] value.
  @override
  LabColor withHue(num hue) {
    assert(hue != null && hue >= 0 && hue <= 360);

    final hslColor = toHslColor();

    return hslColor.withHue((hslColor.hue + hue) % 360).toLabColor();
  }

  @override
  RgbColor toRgbColor() => ColorConverter.labToRgb(this);

  @override
  XyzColor toXyzColor() => ColorConverter.labToXyz(this);

  /// Returns a fixed-length [List] containing the [lightness],
  /// [a], and [b] values, in that order.
  @override
  List<num> toList() => List<num>.from(<num>[lightness, a, b], growable: false);

  /// Returns a fixed-length [List] containing the [lightness],
  /// [a], [b], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[lightness, a, b, alpha], growable: false);

  /// Constructs a [LabColor] from [color].
  factory LabColor.from(ColorModel color) {
    assert(color != null);

    return color.toLabColor();
  }

  /// Constructs a [LabColor] from a list of [lab] values.
  ///
  /// [lab] must not be null and must have exactly `3` or `4` values.
  ///
  /// The first value (L) must be `>= 0 && <= 100`.
  ///
  /// The A and B values must be `>= -128 && <= 127`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 1`.
  factory LabColor.fromList(List<num> lab) {
    assert(lab != null && (lab.length == 3 || lab.length == 4));
    assert(lab[0] != null && lab[0] >= 0 && lab[0] <= 100);
    assert(lab[1] != null && lab[1] >= -128 && lab[1] <= 127);
    assert(lab[2] != null && lab[2] >= -128 && lab[2] <= 127);
    if (lab.length == 4) {
      assert(lab[3] != null && lab[3] >= 0 && lab[3] <= 1);
    }

    final alpha = lab.length == 4 ? lab[3] : 1.0;

    return LabColor(lab[0], lab[1], lab[2], alpha);
  }

  /// Constructs a [LabColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory LabColor.fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toLabColor();
  }

  /// Constructs a [LabColor] from a list of [lab] values on a `0` to `1` scale.
  ///
  /// [lab] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory LabColor.extrapolate(List<double> lab) {
    assert(lab != null && (lab.length == 3 || lab.length == 4));
    assert(lab[0] != null && lab[0] >= 0 && lab[0] <= 1);
    assert(lab[1] != null && lab[1] >= 0 && lab[1] <= 1);
    assert(lab[2] != null && lab[2] >= 0 && lab[2] <= 1);
    if (lab.length == 4) {
      assert(lab[3] != null && lab[3] >= 0 && lab[3] <= 1);
    }

    final alpha = lab.length == 4 ? lab[3] : 1.0;

    return LabColor(
        lab[0] * 100, (lab[1] * 255) - 128, (lab[2] * 255) - 128, alpha);
  }

  @override
  String toString() => 'LabColor($lightness, $a, $b, $alpha)';

  @override
  bool operator ==(Object o) =>
      o is LabColor &&
      lightness == o.lightness &&
      a == o.a &&
      b == o.b &&
      alpha == o.alpha;

  @override
  int get hashCode =>
      lightness.hashCode ^ a.hashCode ^ b.hashCode ^ alpha.hashCode;
}
