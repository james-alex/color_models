import 'package:flutter/material.dart' show Color;
import '../../color_model.dart' as cm;
import '../../flutter_color_model.dart';
import '../../helpers/color_converter.dart';
import './helpers/to_color.dart';

/// A color in the CIELAB color space.
///
/// The CIELAB color space contains channels for [lightness],
/// [a] (red and green opponent values), and [b] (blue and
/// yellow opponent values.)
class LabColor extends cm.LabColor with ToColor {
  /// A color in the CIELAB color space.
  ///
  /// [lightness] must be `>= 0` and `<= 100`.
  ///
  /// [a] and [b] must both be `>= -128` and `<= 127`.
  const LabColor(
    num lightness,
    num a,
    num b,
  )   : assert(lightness != null && lightness >= 0 && lightness <= 100),
        assert(a != null && a >= -128 && a <= 127),
        assert(b != null && b >= -128 && b <= 127),
        super(lightness, a, b);

  /// Parses a list for LAB values and returns a [LabColor].
  ///
  /// [lab] must not be null and must have exactly 3 values.
  ///
  /// The first value (L) must be `>= 0 && <= 100`.
  ///
  /// The A and B values must be `>= -128 && <= 127`.
  static LabColor fromList(List<num> lab) {
    assert(lab != null && lab.length == 3);
    assert(lab[0] != null && lab[0] >= 0 && lab[0] <= 100);
    assert(lab[1] != null && lab[1] >= -128 && lab[1] <= 127);
    assert(lab[2] != null && lab[2] >= -128 && lab[2] <= 127);

    return LabColor(lab[0], lab[1], lab[2]);
  }

  /// Returns [color] as a [LabColor].
  static LabColor fromColor(Color color) {
    assert(color != null);

    return RgbColor.fromColor(color).toLabColor();
  }

  /// Returns a [color] in another color space as a CIELAB color.
  static LabColor from(ColorModel color) {
    assert(color != null);

    color = ToColor.cast(color);

    final lab = ColorConverter.toLabColor(color);

    return LabColor(lab.lightness, lab.a, lab.b);
  }

  /// Returns a [LabColor] from a list of [lab] values on a 0 to 1 scale.
  ///
  /// [lab] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static LabColor extrapolate(List<double> lab) {
    assert(lab != null && lab.length == 3);
    assert(lab[0] != null && lab[0] >= 0 && lab[0] <= 1);
    assert(lab[1] != null && lab[1] >= 0 && lab[1] <= 1);
    assert(lab[2] != null && lab[2] >= 0 && lab[2] <= 1);

    return LabColor(
      lab[0] * 100,
      (lab[1] * 255) - 128,
      (lab[2] * 255) - 128,
    );
  }
}
