import 'package:flutter/material.dart' show Color;
import '../../color_model.dart' as cm;
import '../../flutter_color_model.dart';
import '../../helpers/color_converter.dart';
import './helpers/to_color.dart';

/// A color in the CIEXYZ color space.
class XyzColor extends cm.XyzColor with ToColor {
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
    num x,
    num y,
    num z,
  )   : assert(x != null && x >= 0),
        assert(y != null && y >= 0),
        assert(z != null && z >= 0),
        super(x, y, z);

  /// Parses a list for XYZ values and returns a [XyzColor].
  ///
  /// [xyz] must not be null and must have exactly 3 values.
  ///
  /// [x] must be `>= 0` and `<= 95`.
  ///
  /// [y] must be `>= 0` and `<= 100`.
  ///
  /// [z] must be `>= 0` and `<= 109`.
  ///
  /// None of the color values may be null.
  static XyzColor fromList(List<num> xyz) {
    assert(xyz != null && xyz.length == 3);
    assert(xyz[0] != null && xyz[0] >= 0 && xyz[0] <= 100);
    assert(xyz[1] != null && xyz[1] >= 0 && xyz[1] <= 100);
    assert(xyz[2] != null && xyz[2] >= 0 && xyz[2] <= 100);

    return XyzColor(xyz[0], xyz[1], xyz[2]);
  }

  /// Returns [color] as a [XyzColor].
  static XyzColor fromColor(Color color) {
    assert(color != null);

    return RgbColor.fromColor(color).toXyzColor();
  }

  /// Returns a [color] in another color space as a XYZ color.
  static XyzColor from(ColorModel color) {
    assert(color != null);

    color = ToColor.cast(color);

    final xyz = ColorConverter.toXyzColor(color);

    return XyzColor(xyz.x, xyz.y, xyz.z);
  }

  /// Returns a [XyzColor] from a list of [xyz] values on a 0 to 1 scale.
  ///
  /// [xyz] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static XyzColor extrapolate(List<double> xyz) {
    assert(xyz != null && xyz.length == 3);
    assert(xyz[0] != null && xyz[0] >= 0 && xyz[0] <= 1);
    assert(xyz[1] != null && xyz[1] >= 0 && xyz[1] <= 1);
    assert(xyz[2] != null && xyz[2] >= 0 && xyz[2] <= 1);

    final xyzValues = xyz.map((xyzValue) => xyzValue * 100).toList();

    return fromList(xyzValues);
  }
}
