import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';
import '../helpers/color_math.dart';

/// {@template color_models.CmykColor}
///
/// A color in the CMYK color space.
///
/// The CMYK color space contains channels for [cyan],
/// [magenta], [yellow], and [black].
///
/// {@endtemplate}
@immutable
class CmykColor extends ColorModel {
  /// {@template color_models.CmykColor.constructor}
  ///
  /// A color in the CMYK color space.
  ///
  /// [cyan], [magenta], [yellow], and [black]
  /// must all be `>= 0` and `<= 100`.
  ///
  /// [alpha] must be `>= 0` and `<= 255`.
  ///
  /// {@endtemplate}
  const CmykColor(
    this.cyan,
    this.magenta,
    this.yellow,
    this.black, [
    int alpha = 255,
  ])  : assert(cyan >= 0 && cyan <= 100),
        assert(magenta >= 0 && magenta <= 100),
        assert(yellow >= 0 && yellow <= 100),
        assert(black >= 0 && black <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(alpha: alpha);

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
  bool get isBlack => ColorMath.round(black) == 100;

  @override
  bool get isWhite =>
      ColorMath.round(cyan) == 0 &&
      ColorMath.round(magenta) == 0 &&
      ColorMath.round(yellow) == 0 &&
      ColorMath.round(black) == 0;

  @override
  bool get isMonochromatic =>
      ColorMath.round(cyan) == 0 &&
      ColorMath.round(magenta) == 0 &&
      ColorMath.round(yellow) == 0;

  @override
  CmykColor interpolate(ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step) as CmykColor;
  }

  @override
  List<CmykColor> lerpTo(
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
        .cast<CmykColor>();
  }

  @override
  CmykColor get inverted {
    final values = toList();
    return CmykColor.fromList(
        List<num>.generate(values.length, (i) => 100 - values[i])..add(alpha));
  }

  @override
  CmykColor get opposite => rotateHue(180);

  @override
  CmykColor rotateHue(num amount) =>
      ColorAdjustments.rotateHue(this, amount).toCmykColor();

  @override
  CmykColor rotateHueRad(double amount) =>
      ColorAdjustments.rotateHueRad(this, amount).toCmykColor();

  @override
  CmykColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    if (relative) assert(amount <= 100);
    return ColorAdjustments.warmer(this, amount, relative: relative)
        .toCmykColor();
  }

  @override
  CmykColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    if (relative) assert(amount <= 100);
    return ColorAdjustments.cooler(this, amount, relative: relative)
        .toCmykColor();
  }

  /// Returns this [XyzColor] modified with the provided [hue] value.
  @override
  CmykColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toCmykColor();
  }

  @override
  CmykColor withChroma(double chroma) =>
      toOklabColor().withChroma(chroma).toCmykColor();

  /// Returns this [CmykColor] modified with the provided [alpha] value.
  @override
  CmykColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  @override
  CmykColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  @override
  CmykColor fromValues(List<num> values) {
    assert(values.length == 4 || values.length == 5);
    assert(values[0] >= 0 && values[0] <= 100);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    assert(values[3] >= 0 && values[3] <= 100);
    if (values.length == 5) assert(values[4] >= 0 && values[4] <= 255);
    return CmykColor.fromList(values);
  }

  @override
  CmykColor copyWith({
    num? cyan,
    num? magenta,
    num? yellow,
    num? black,
    int? alpha,
  }) {
    assert(cyan == null || (cyan >= 0 && cyan <= 100));
    assert(magenta == null || (magenta >= 0 && magenta <= 100));
    assert(yellow == null || (yellow >= 0 && yellow <= 100));
    assert(black == null || (black >= 0 && black <= 100));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return CmykColor(
      cyan ?? this.cyan,
      magenta ?? this.magenta,
      yellow ?? this.yellow,
      black ?? this.black,
      alpha ?? this.alpha,
    );
  }

  @override
  RgbColor toRgbColor() => ColorConverter.cmykToRgb(this);

  @override
  CmykColor toCmykColor() => this;

  /// Returns a fixed-length list containing the [cyan],
  /// [magenta], [yellow], and [black] values, in that order.
  @override
  List<num> toList() =>
      List<num>.from(<num>[cyan, magenta, yellow, black], growable: false);

  /// Returns a fixed-length list containing the [cyan], [magenta],
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
  List<double> toFactoredListWithAlpha() => List<double>.from(<double>[
        cyan / 100,
        magenta / 100,
        yellow / 100,
        black / 100,
        alpha / 255,
      ], growable: false);

  /// {@template color_models.CmykColor.from}
  ///
  /// Constructs a [CmykColor] from [color].
  ///
  /// {@endtemplate}
  factory CmykColor.from(ColorModel color) => color.toCmykColor();

  /// {@template color_models.CmykColor.fromList}
  ///
  /// Constructs a [CmykColor] from a list of [cmyk] values.
  ///
  /// [cmyk] must not be null and must have exactly `4` or `5` values.
  ///
  /// Each color value must be `>= 0 && <= 100`.
  ///
  /// The [alpha] value, if provided, must be `>= 0 && <= 255`.
  ///
  /// {@endtemplate}
  factory CmykColor.fromList(List<num> values) {
    assert(values.length == 4 || values.length == 5);
    assert(values[0] >= 0 && values[0] <= 100);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    assert(values[3] >= 0 && values[3] <= 100);
    if (values.length == 5) assert(values[4] >= 0 && values[4] <= 255);
    final alpha = values.length == 5 ? values[4].round() : 255;
    return CmykColor(values[0], values[1], values[2], values[3], alpha);
  }

  /// {@template color_models.CmykColor.fromHex}
  ///
  /// Constructs a [CmykColor] from a RGB [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  ///
  /// {@endtemplate}
  factory CmykColor.fromHex(String hex) =>
      ColorConverter.hexToRgb(hex).toCmykColor();

  /// {@template color_models.CmykColor.extrapolate}
  ///
  /// Constructs a [CmykColor] from a list of [cmyk] values
  /// on a `0` to `1` scale.
  ///
  /// [cmyk] must not be null and must have exactly `4` or `5` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  ///
  /// {@endtemplate}
  factory CmykColor.extrapolate(List<double> values) {
    assert(values.length == 4 || values.length == 5);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    assert(values[3] >= 0 && values[3] <= 1);
    if (values.length == 5) assert(values[4] >= 0 && values[4] <= 255);
    final alpha = values.length == 5 ? (values[4] * 255).round() : 255;
    return CmykColor(values[0] * 100, values[1] * 100, values[2] * 100,
        values[3] * 100, alpha);
  }

  /// {@template color_models.CmykColor.random}
  ///
  /// Generates a [CmykColor] at random.
  ///
  /// [minCyan] and [maxCyan] constrain the generated [cyan] value.
  ///
  /// [minMagenta] and [maxMagenta] constrain the generated [magenta] value.
  ///
  /// [minYellow] and [maxYellow] constrain the generated [yellow] value.
  ///
  /// [minBlack] and [maxBlack] constrain the generated [black] value.
  ///
  /// All min and max values must be `min <= max && max >= min`, must be
  /// in the range of `>= 0 && <= 100`, and must not be `null`.
  ///
  /// {@endtemplate}
  factory CmykColor.random({
    num minCyan = 0,
    num maxCyan = 100,
    num minMagenta = 0,
    num maxMagenta = 100,
    num minYellow = 0,
    num maxYellow = 100,
    num minBlack = 0,
    num maxBlack = 100,
    int? seed,
  }) {
    assert(minCyan >= 0 && minCyan <= maxCyan);
    assert(maxCyan >= minCyan && maxCyan <= 100);
    assert(minMagenta >= 0 && minMagenta <= maxMagenta);
    assert(maxMagenta >= minMagenta && maxMagenta <= 100);
    assert(minYellow >= 0 && minYellow <= maxYellow);
    assert(maxYellow >= minYellow && maxYellow <= 100);
    assert(minBlack >= 0 && minBlack <= maxBlack);
    assert(maxBlack >= minBlack && maxBlack <= 100);

    return CmykColor(
      ColorMath.random(minCyan, maxCyan, seed),
      ColorMath.random(minMagenta, maxMagenta, seed),
      ColorMath.random(minYellow, maxYellow, seed),
      ColorMath.random(minBlack, maxBlack, seed),
    );
  }

  @override
  CmykColor convert(ColorModel other) => other.toCmykColor();

  @override
  String toString() => 'CmykColor($cyan, $magenta, $yellow, $black, $alpha)';

  @override
  bool operator ==(Object other) =>
      other is CmykColor &&
      ColorMath.round(cyan) == ColorMath.round(other.cyan) &&
      ColorMath.round(magenta) == ColorMath.round(other.magenta) &&
      ColorMath.round(yellow) == ColorMath.round(other.yellow) &&
      ColorMath.round(black) == ColorMath.round(other.black) &&
      alpha == other.alpha;

  @override
  int get hashCode =>
      cyan.hashCode ^
      magenta.hashCode ^
      yellow.hashCode ^
      black.hashCode ^
      alpha.hashCode;
}
