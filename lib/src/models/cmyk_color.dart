import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';

/// A color in the CMYK color space.
///
/// The CMYK color space contains channels for [cyan],
/// [magenta], [yellow], and [black].
@immutable
class CmykColor extends ColorModel {
  /// A color in the CMYK color space.
  ///
  /// [cyan], [magenta], [yellow], and [black]
  /// must all be `>= 0` and `<= 100`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  const CmykColor(
    this.cyan,
    this.magenta,
    this.yellow,
    this.black, [
    this.alpha = 1.0,
  ])  : assert(cyan != null && cyan >= 0 && cyan <= 100),
        assert(magenta != null && magenta >= 0 && magenta <= 100),
        assert(yellow != null && yellow >= 0 && yellow <= 100),
        assert(black != null && black >= 0 && black <= 100),
        assert(alpha != null && alpha >= 0 && alpha <= 1);

  /// The cyan value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num cyan;

  /// The magenta value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num magenta;

  /// The yellow value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num yellow;

  /// The black value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num black;

  @override
  final num alpha;

  @override
  bool get isBlack => (black == 100);

  @override
  bool get isWhite => (cyan == 0 && magenta == 0 && yellow == 0 && black == 0);

  @override
  CmykColor get inverted {
    final values = toList();

    return CmykColor.fromList(
        List<num>.generate(values.length, (i) => 100 - values[i])..add(alpha));
  }

  @override
  CmykColor get opposite => rotateHue(180);

  @override
  CmykColor rotateHue(num amount) {
    assert(amount != null);

    return ColorAdjustments.rotateHue(this, amount).toCmykColor();
  }

  @override
  CmykColor warmer(num amount, {bool relative = true}) {
    assert(amount != null && amount > 0);
    assert(relative != null);
    if (relative) assert(amount <= 100);

    return ColorAdjustments.warmer(this, amount, relative: relative)
        .toCmykColor();
  }

  @override
  CmykColor cooler(num amount, {bool relative = true}) {
    assert(amount != null && amount > 0);
    assert(relative != null);
    if (relative) assert(amount <= 100);

    return ColorAdjustments.cooler(this, amount, relative: relative)
        .toCmykColor();
  }

  /// Returns this [CmykColor] modified with the provided [cyan] value.
  CmykColor withCyan(num cyan) {
    assert(cyan != null && cyan >= 0 && cyan <= 100);

    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  /// Returns this [CmykColor] modified with the provided [magenta] value.
  CmykColor withMagenta(num magenta) {
    assert(magenta != null && magenta >= 0 && magenta <= 100);

    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  /// Returns this [CmykColor] modified with the provided [yellow] value.
  CmykColor withYellow(num yellow) {
    assert(yellow != null && yellow >= 0 && yellow <= 100);

    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  /// Returns this [CmykColor] modified with the provided [black] value.
  CmykColor withBlack(num black) {
    assert(black != null && black >= 0 && black <= 100);

    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  @override
  CmykColor withAlpha(num alpha) {
    assert(alpha != null && alpha >= 0 && alpha <= 1);

    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  /// Returns this [XyzColor] modified with the provided [hue] value.
  @override
  CmykColor withHue(num hue) {
    assert(hue != null && hue >= 0 && hue <= 360);

    final hslColor = toHslColor();

    return hslColor.withHue((hslColor.hue + hue) % 360).toCmykColor();
  }

  @override
  RgbColor toRgbColor() => ColorConverter.cmykToRgb(this);

  /// Returns a fixed-length [List] containing the [cyan],
  /// [magenta], [yellow], and [black] values, in that order.
  @override
  List<num> toList() =>
      List<num>.from(<num>[cyan, magenta, yellow, black], growable: false);

  /// Returns a fixed-length [List] containing the [cyan], [magenta],
  /// [yellow], [black], and [alpha] values, in that order.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[cyan, magenta, yellow, black, alpha],
          growable: false);

  /// Returns a fixed-length list containing the [cyan], [magenta],
  /// [yelllow], and [black] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() =>
      toList().map((cmykValue) => cmykValue / 100).toList(growable: false);

  /// Returns a fixed-length list containing the [cyan], [magenta], [yelllow],
  /// [black], and [alpha] values factored to be on 0 to 1 scale.
  List<double> toFactoredListWithAlpha() => List<double>.from(
      <double>[cyan / 100, magenta / 100, yellow / 100, black / 100, alpha],
      growable: false);

  /// Constructs a [CmykColor] from [color].
  factory CmykColor.from(ColorModel color) {
    assert(color != null);

    return color.toCmykColor();
  }

  /// Constructs a [CmykColor] from a list of [cmyk] values.
  ///
  /// [cmyk] must not be null and must have exactly `4` or `5` values.
  ///
  /// Each color value must be `>= 0 && <= 100`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 1`.
  factory CmykColor.fromList(List<num> cmyk) {
    assert(cmyk != null && (cmyk.length == 4 || cmyk.length == 5));
    assert(cmyk[0] != null && cmyk[0] >= 0 && cmyk[0] <= 100);
    assert(cmyk[1] != null && cmyk[1] >= 0 && cmyk[1] <= 100);
    assert(cmyk[2] != null && cmyk[2] >= 0 && cmyk[2] <= 100);
    assert(cmyk[3] != null && cmyk[3] >= 0 && cmyk[3] <= 100);
    if (cmyk.length == 5) {
      assert(cmyk[4] != null && cmyk[4] >= 0 && cmyk[4] <= 1);
    }

    final alpha = cmyk.length == 5 ? cmyk[4] : 1.0;

    return CmykColor(cmyk[0], cmyk[1], cmyk[2], cmyk[3], alpha);
  }

  /// Constructs a [CmykColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory CmykColor.fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toCmykColor();
  }

  /// Constructs a [CmykColor] from a list of [cmyk] values
  /// on a `0` to `1` scale.
  ///
  /// [cmyk] must not be null and must have exactly `4` or `5` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory CmykColor.extrapolate(List<double> cmyk) {
    assert(cmyk != null && (cmyk.length == 4 || cmyk.length == 5));
    assert(cmyk[0] != null && cmyk[0] >= 0 && cmyk[0] <= 1);
    assert(cmyk[1] != null && cmyk[1] >= 0 && cmyk[1] <= 1);
    assert(cmyk[2] != null && cmyk[2] >= 0 && cmyk[2] <= 1);
    assert(cmyk[3] != null && cmyk[3] >= 0 && cmyk[3] <= 1);
    if (cmyk.length == 5) {
      assert(cmyk[4] != null && cmyk[4] >= 0 && cmyk[4] <= 1);
    }

    final alpha = cmyk.length == 5 ? cmyk[4] : 1.0;

    return CmykColor(
        cmyk[0] * 100, cmyk[1] * 100, cmyk[2] * 100, cmyk[3] * 100, alpha);
  }

  @override
  String toString() => 'CmykColor($cyan, $magenta, $yellow, $black, $alpha)';

  @override
  bool operator ==(Object o) =>
      o is CmykColor &&
      cyan == o.cyan &&
      magenta == o.magenta &&
      yellow == o.yellow &&
      black == o.black &&
      alpha == o.alpha;

  @override
  int get hashCode =>
      cyan.hashCode ^
      magenta.hashCode ^
      yellow.hashCode ^
      black.hashCode ^
      alpha.hashCode;
}
