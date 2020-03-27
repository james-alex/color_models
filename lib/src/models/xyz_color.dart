import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';
import '../helpers/random.dart';
import '../helpers/round_values.dart';

/// A color in the CIEXYZ color space.
@immutable
class XyzColor extends ColorModel {
  /// A color in the CIEXYZ color space.
  ///
  /// [x], [y], and [z] must all be `>= 0`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  ///
  /// The XYZ values have been normalized to a 0 to 100 range that
  /// represents the whole of the sRGB color space, but have been
  /// left upwardly unbounded to allow to allow for conversions
  /// between the XYZ and LAB color spaces that fall outside of
  /// the sRGB color space's bounds.
  const XyzColor(
    this.x,
    this.y,
    this.z, [
    this.alpha = 1.0,
  ])  : assert(x != null && x >= 0),
        assert(y != null && y >= 0),
        assert(z != null && z >= 0),
        assert(alpha != null && alpha >= 0 && alpha <= 1);

  /// The x value of this color.
  ///
  /// Ranges from `0` to `100` in the normal sRGB spectrum, but colors
  /// outside of the sRGB spectrum are upwardly unbounded.
  final num x;

  /// The y value of this color.
  ///
  /// Ranges from `0` to `100` in the normal sRGB spectrum, but colors
  /// outside of the sRGB spectrum are upwardly unbounded.
  final num y;

  /// The x value of this color.
  ///
  /// Ranges from `0` to `100` in the normal sRGB spectrum, but colors
  /// outside of the sRGB spectrum are upwardly unbounded.
  final num z;

  @override
  final num alpha;

  @override
  bool get isBlack => round(x) == 0 && round(y) == 0 && round(z) == 0;

  @override
  bool get isWhite => round(x) >= 100 && round(y) >= 100 && round(z) >= 100;

  @override
  bool get isMonochromatic {
    final x = round(this.x);
    return  x == round(y) && x == round(z);
  }

  @override
  XyzColor get inverted {
    final values = toList();

    return XyzColor.fromList(
        List<num>.generate(values.length, (i) => 100 - values[i].clamp(0, 100))
          ..add(alpha));
  }

  @override
  XyzColor get opposite => rotateHue(180);

  @override
  XyzColor rotateHue(num amount) {
    assert(amount != null);

    return ColorAdjustments.rotateHue(this, amount).toXyzColor();
  }

  @override
  XyzColor warmer(num amount, {bool relative = true}) {
    assert(amount != null && amount > 0);

    return ColorAdjustments.warmer(this, amount, relative: relative)
        .toXyzColor();
  }

  @override
  XyzColor cooler(num amount, {bool relative = true}) {
    assert(amount != null && amount > 0);

    return ColorAdjustments.cooler(this, amount, relative: relative)
        .toXyzColor();
  }

  /// Returns this [XyzColor] modified with the provided [x] value.
  XyzColor withX(num x) {
    assert(x != null && x >= 0);

    return XyzColor(x, y, z, alpha);
  }

  /// Returns this [XyzColor] modified with the provided [y] value.
  XyzColor withY(num y) {
    assert(y != null && y >= 0);

    return XyzColor(x, y, z, alpha);
  }

  /// Returns this [XyzColor] modified with the provided [z] value.
  XyzColor withZ(num z) {
    assert(z != null && z >= 0);

    return XyzColor(x, y, z, alpha);
  }

  /// Returns this [XyzColor] modified with the provided [alpha] value.
  @override
  XyzColor withAlpha(num alpha) {
    assert(alpha != null && alpha >= 0 && alpha <= 1);

    return XyzColor(x, y, z, alpha);
  }

  /// Returns this [XyzColor] modified with the provided [hue] value.
  @override
  XyzColor withHue(num hue) {
    assert(hue != null && hue >= 0 && hue <= 360);

    final hslColor = toHslColor();

    return hslColor.withHue((hslColor.hue + hue) % 360).toXyzColor();
  }

  @override
  LabColor toLabColor() => ColorConverter.xyzToLab(this);

  @override
  RgbColor toRgbColor() => ColorConverter.xyzToRgb(this);

  /// Returns a fixed-length [List] containing the
  /// [x], [y], and [z] values, in that order.
  @override
  List<num> toList() => List<num>.from(<num>[x, y, z], growable: false);

  /// Returns a fixed-length [List] containing the
  /// [x], [y], [z], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[x, y, z, alpha], growable: false);

  /// Returns a fixed-length list containing the [x], [y], and
  /// [z] values factored to be on a 0 to 1 scale.
  List<double> toFactoredList() =>
      toList().map((xyzValue) => xyzValue / 100).toList(growable: false);

  /// Returns a fixed-length list containing the [x], [y], and
  /// [z] values factored to be on a 0 to 1 scale.
  List<double> toFactoredListWithAlpha() =>
      List<double>.from(<double>[x / 100, y / 100, z / 100, alpha],
          growable: false);

  /// Constructs a [XyzColor] from [color].
  factory XyzColor.from(ColorModel color) {
    assert(color != null);

    return color.toXyzColor();
  }

  /// Constructs a [XyzColor] from a list of [xyz] values.
  ///
  /// [xyz] must not be null and must have exactly `3` or `4` values.
  ///
  /// [x], [y], and [z] all must not be null and must be `>= 0`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 1`.
  factory XyzColor.fromList(List<num> xyz) {
    assert(xyz != null && (xyz.length == 3 || xyz.length == 4));
    assert(xyz[0] != null && xyz[0] >= 0);
    assert(xyz[1] != null && xyz[1] >= 0);
    assert(xyz[2] != null && xyz[2] >= 0);
    if (xyz.length == 4) {
      assert(xyz[3] != null && xyz[3] >= 0 && xyz[3] <= 1);
    }

    final alpha = xyz.length == 4 ? xyz[3] : 1.0;

    return XyzColor(xyz[0], xyz[1], xyz[2], alpha);
  }

  /// Constructs a [XyzColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory XyzColor.fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toXyzColor();
  }

  /// Constructs a [XyzColor] from a list of [xyz] values on a `0` to `1` scale.
  ///
  /// [xyz] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory XyzColor.extrapolate(List<double> xyz) {
    assert(xyz != null && (xyz.length == 3 || xyz.length == 4));
    assert(xyz[0] != null && xyz[0] >= 0);
    assert(xyz[1] != null && xyz[1] >= 0);
    assert(xyz[2] != null && xyz[2] >= 0);
    if (xyz.length == 4) {
      assert(xyz[3] != null && xyz[3] >= 0 && xyz[3] <= 1);
    }

    final alpha = xyz.length == 4 ? xyz[3] : 1.0;

    return XyzColor(xyz[0] * 100, xyz[1] * 100, xyz[2] * 100, alpha);
  }

  /// Generates a [XyzColor] at random.
  ///
  /// [minX] and [maxX] constrain the generated [x] value.
  ///
  /// [minY] and [maxY] constrain the generated [y] value.
  ///
  /// [minZ] and [maxZ] constrain the generated [z] value.
  ///
  /// All min and max values must be `min <= max && max >= min`, must be
  /// in the range of `>= 0 && <= 100`, and must not be `null`.
  factory XyzColor.random({
    num minX = 0,
    num maxX = 100,
    num minY = 0,
    num maxY = 100,
    num minZ = 0,
    num maxZ = 100,
  }) {
    assert(minX != null && minX >= 0 && minX <= maxX);
    assert(maxX != null && maxX >= minX && maxX <= 100);
    assert(minY != null && minY >= 0 && minY <= maxY);
    assert(maxY != null && maxY >= minY && maxY <= 100);
    assert(minZ != null && minZ >= 0 && minZ <= maxZ);
    assert(maxZ != null && maxZ >= minZ && maxZ <= 100);

    return XyzColor(
      random(minX, maxX),
      random(minY, maxY),
      random(minZ, maxZ),
    );
  }

  /// The whitepoints used when calculating the XYZ values
  /// to normalize all 3 values to the 0 to 100 range.
  ///
  /// These white points were calculated for this plugin, as such they
  /// are not derived from one of the CIE standard illuminants.
  static const _WhitePoints whitePoint = _WhitePoints(
    x: 105.21266389510953,
    y: 100.0000000000007,
    z: 91.82249511582535,
  );

  @override
  String toString() => 'XyzColor($x, $y, $z, $alpha)';

  @override
  bool operator ==(Object o) =>
      o is XyzColor &&
      round(x) == round(o.x) &&
      round(y) == round(o.y) &&
      round(z) == round(o.z) &&
      alpha == o.alpha;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode ^ alpha.hashCode;
}

class _WhitePoints {
  const _WhitePoints({
    @required this.x,
    @required this.y,
    @required this.z,
  })  : assert(x != null),
        assert(y != null),
        assert(z != null);

  final num x;
  final num y;
  final num z;
}
