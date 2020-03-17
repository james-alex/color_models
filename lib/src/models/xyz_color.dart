import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_converter.dart';

/// A color in the CIEXYZ color space.
@immutable
class XyzColor extends ColorModel {
  /// A color in the CIEXYZ color space.
  ///
  /// [x], [y], and [z] must all be `>= 0`.
  ///
  /// The XYZ values have been normalized to a 0 to 100 range that
  /// represents the whole of the sRGB color space, but have been
  /// left upwardly unbounded to allow to allow for conversions
  /// between the XYZ and LAB color spaces that fall outside of
  /// the sRGB color space's bounds.
  XyzColor(
    this.x,
    this.y,
    this.z,
  )   : assert(x != null && x >= 0),
        assert(y != null && y >= 0),
        assert(z != null && z >= 0);

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
  bool get isBlack => (x == 0 && y == 0 && z == 0);

  @override
  bool get isWhite => (x == 100 && y == 100 && z == 100);

  @override
  LabColor toLabColor() => ColorConverter.xyzToLab(this);

  @override
  RgbColor toRgbColor() => ColorConverter.xyzToRgb(this);

  /// Returns a fixed-length [List] containing the
  /// [x], [y], and [z] values in that order.
  @override
  List<num> toList() {
    final list = List<num>(3);

    list[0] = x;
    list[1] = y;
    list[2] = z;

    return list;
  }

  /// Returns a fixed-length list containing the [x], [y], and
  /// [z] values factored to be on a 0 to 1 scale.
  List<double> toFactoredList() =>
      toList().map((xyzValue) => xyzValue / 100).toList();

  /// Parses a list for XYZ values and returns a [XyzColor].
  ///
  /// [xyz] must not be null and must have exactly 3 values.
  ///
  /// [x], [y], and [z] all must not be null and must be `>= 0`.
  static XyzColor fromList(List<num> xyz) {
    assert(xyz != null && xyz.length == 3);
    assert(xyz[0] != null && xyz[0] >= 0);
    assert(xyz[1] != null && xyz[1] >= 0);
    assert(xyz[2] != null && xyz[2] >= 0);

    return XyzColor(xyz[0], xyz[1], xyz[2]);
  }

  /// Returns a [color] in another color space as a XYZ color.
  static XyzColor from(ColorModel color) {
    assert(color != null);

    return color.toXyzColor();
  }

  /// Returns a [hex] color as a CIEXYZ color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  static XyzColor fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toXyzColor();
  }

  /// Returns a [XyzColor] from a list of [xyz] values on a 0 to 1 scale.
  ///
  /// [xyz] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static XyzColor extrapolate(List<double> xyz) {
    assert(xyz != null && xyz.length == 3);
    assert(xyz[0] != null && xyz[0] >= 0);
    assert(xyz[1] != null && xyz[1] >= 0);
    assert(xyz[2] != null && xyz[2] >= 0);

    final xyzValues = xyz.map((xyzValue) => xyzValue * 100).toList();

    return fromList(xyzValues);
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
  String toString() => 'XyzColor($x, $y, $z)';

  @override
  bool operator ==(Object o) =>
      o is XyzColor && x == o.x && y == o.y && z == o.z;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
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
