import '../color_model.dart';
import '../helpers/color_converter.dart';

/// A color in the CIELAB color space.
///
/// The CIELAB color space contains channels for [lightness],
/// [a] (red and green opponent values), and [b] (blue and
/// yellow opponent values.)
class LabColor extends ColorModel {
  /// A color in the CIELAB color space.
  ///
  /// [lightness] must be `>= 0` and `<= 100`.
  ///
  /// [a] and [b] must both be `>= -128` and `<= 127`.
  const LabColor(
    this.lightness,
    this.a,
    this.b,
  )   : assert(lightness != null && lightness >= 0 && lightness <= 100),
        assert(a != null && a >= -128 && a <= 127),
        assert(b != null && b >= -128 && b <= 127);

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
  bool get isBlack => (lightness == 0 && a == 0 && b == 0);

  @override
  bool get isWhite => (lightness == 1 && a == 0 && b == 0);

  @override
  RgbColor toRgbColor() => ColorConverter.labToRgb(this);

  @override
  XyzColor toXyzColor() => ColorConverter.labToXyz(this);

  /// Returns a fixed-length [List] containing the [lightness],
  /// [a], and [b] values in that order.
  @override
  List<num> toList() {
    final list = List<num>(3);

    list[0] = lightness;
    list[1] = a;
    list[2] = b;

    return list;
  }

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

  /// Returns a [color] from another color space as a CIELAB color.
  static LabColor from(ColorModel color) {
    assert(color != null);

    return color.toLabColor();
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

  @override
  bool operator ==(Object o) =>
      o is LabColor && lightness == o.lightness && a == o.a && b == o.b;

  @override
  int get hashCode => lightness.hashCode ^ a.hashCode ^ b.hashCode;
}
