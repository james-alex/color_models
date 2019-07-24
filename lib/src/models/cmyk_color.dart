import '../color_model.dart';

/// A color in the CMYK color space.
///
/// The CMYK color space contains channels for [cyan],
/// [magenta], [yellow], and [black].
class CmykColor extends ColorModel {
  /// A color in the CMYK color space.
  ///
  /// [cyan], [magenta], [yellow], and [black]
  /// must all be `>= 0` and `<= 100`.
  const CmykColor(
    this.cyan,
    this.magenta,
    this.yellow,
    this.black,
  )   : assert(cyan != null && cyan >= 0 && cyan <= 100),
        assert(magenta != null && magenta >= 0 && magenta <= 100),
        assert(yellow != null && yellow >= 0 && yellow <= 100),
        assert(black != null && black >= 0 && black <= 100);

  final num cyan;

  final num magenta;

  final num yellow;

  final num black;

  @override
  bool get isBlack => (black == 100);

  @override
  bool get isWhite => (cyan == 0 && magenta == 0 && yellow == 0 && black == 0);

  /// Returns a fixed-length [List] containing the [cyan],
  /// [magenta], [yellow], and [black] values in that order.
  @override
  List<num> toList() {
    final List<num> list = List<num>(4);

    list[0] = cyan;
    list[1] = magenta;
    list[2] = yellow;
    list[3] = black;

    return list;
  }

  /// Returns a fixed-length list containing the [cyan], [magenta],
  /// [yelllow], and [black] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => toList()
      .map(
        (num cmykValue) => cmykValue / 100,
      )
      .toList();

  /// Parses a list for CMYK values and returns a [CmykColor].
  ///
  /// [cmyk] must not be null and must have exactly 4 values.
  ///
  /// Each color value must be `>= 0 && <= 100`.
  static CmykColor fromList(List<num> cmyk) {
    assert(cmyk != null && cmyk.length == 4);
    assert(cmyk[0] != null && cmyk[0] >= 0 && cmyk[0] <= 100);
    assert(cmyk[1] != null && cmyk[1] >= 0 && cmyk[1] <= 100);
    assert(cmyk[2] != null && cmyk[2] >= 0 && cmyk[2] <= 100);
    assert(cmyk[3] != null && cmyk[3] >= 0 && cmyk[3] <= 100);

    return CmykColor(cmyk[0], cmyk[1], cmyk[2], cmyk[3]);
  }

  /// Converts a [color] from another color space to CMYK.
  static CmykColor from(ColorModel color) {
    assert(color != null);

    return color.toCmykColor();
  }

  /// Returns a [CmykColor] from a list of [cmyk] values on a 0 to 1 scale.
  ///
  /// [cmyk] must not be null and must have exactly 4 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static CmykColor extrapolate(List<double> cmyk) {
    assert(cmyk != null && cmyk.length == 4);
    assert(cmyk[0] != null && cmyk[0] >= 0 && cmyk[0] <= 1);
    assert(cmyk[1] != null && cmyk[1] >= 0 && cmyk[1] <= 1);
    assert(cmyk[2] != null && cmyk[2] >= 0 && cmyk[2] <= 1);
    assert(cmyk[3] != null && cmyk[3] >= 0 && cmyk[3] <= 1);

    final List<double> cmykValues = cmyk
        .map(
          (double cmykValue) => cmykValue * 100,
        )
        .toList();

    return CmykColor.fromList(cmykValues);
  }

  @override
  operator ==(o) =>
      o is CmykColor &&
      cyan == o.cyan &&
      magenta == o.magenta &&
      yellow == o.yellow &&
      black == o.black;
}
