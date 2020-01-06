import '../color_model.dart';

/// A color in the sRGB color space.
///
/// The sRGB color space contains channels for [red], [green], and [blue].
///
/// [RgbColor] stores RGB values as [num]s privately in order to avoid
/// a loss of precision when converting between color spaces, but has
/// getters set for [red], [green], and [blue] that return the rounded
/// [int] values. The precise values can returned as a list with the
/// `toPreciseList()` method.
class RgbColor extends ColorModel {
  /// A color in the sRGB color space.
  ///
  /// [_red], [_green], and [_blue] must all be `>= 0` and `<= 255`.
  const RgbColor(
    this._red,
    this._green,
    this._blue,
  )   : assert(_red != null && _red >= 0 && _red <= 255),
        assert(_green != null && _green >= 0 && _green <= 255),
        assert(_blue != null && _blue >= 0 && _blue <= 255);

  int get red => _red.round();
  final num _red;

  int get green => _green.round();
  final num _green;

  int get blue => _blue.round();
  final num _blue;

  @override
  bool get isBlack => (red == 0 && green == 0 && blue == 0);

  @override
  bool get isWhite => (red == 255 && green == 255 && blue == 255);

  @override
  RgbColor toRgbColor() => this;

  /// Returns a fixed-length list containing the RGB values.
  @override
  List<int> toList() => List.from(<int>[red, green, blue], growable: false);

  /// Returns a fixed-length list containing the precise RGB values.
  List<num> toPreciseList() =>
      List.from(<num>[_red, _green, _blue], growable: false);

  /// Returns a fixed-length list containing the [red], [green],
  /// and [blue] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() =>
      toPreciseList().map((num rgbValue) => rgbValue / 255).toList();

  /// Parses a list for RGB values and returns a [RgbColor].
  ///
  /// [rgb] must not be null and must have exactly 3 values.
  ///
  /// Each color value must be `>= 0 && <= 255`.
  static RgbColor fromList(List<num> rgb) {
    assert(rgb != null && rgb.length == 3);
    assert(rgb[0] != null && rgb[0] >= 0 && rgb[0] <= 255);
    assert(rgb[1] != null && rgb[1] >= 0 && rgb[1] <= 255);
    assert(rgb[2] != null && rgb[2] >= 0 && rgb[2] <= 255);

    return RgbColor(rgb[0], rgb[1], rgb[2]);
  }

  /// Converts a [color] from another color space to RGB.
  static RgbColor from(ColorModel color) {
    assert(color != null);

    return color.toRgbColor();
  }

  /// Returns a [RgbColor] from a list of [rgb] values on a 0 to 1 scale.
  ///
  /// [rgb] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static RgbColor extrapolate(List<double> rgb) {
    assert(rgb != null && rgb.length == 3);
    assert(rgb[0] != null && rgb[0] >= 0 && rgb[0] <= 1);
    assert(rgb[1] != null && rgb[1] >= 0 && rgb[1] <= 1);
    assert(rgb[2] != null && rgb[2] >= 0 && rgb[2] <= 1);

    final List<double> rgbValues = rgb
        .map(
          (double rgbValue) => rgbValue * 255,
        )
        .toList();

    return fromList(rgbValues);
  }

  @override
  bool operator ==(o) =>
      o is RgbColor && red == o.red && green == o.green && blue == o.blue;

  @override
  int get hashCode => red.hashCode ^ green.hashCode ^ blue.hashCode;
}
