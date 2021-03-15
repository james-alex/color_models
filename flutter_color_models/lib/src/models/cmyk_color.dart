import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// A color in the CMYK color space.
///
/// The CMYK color space contains channels for [cyan],
/// [magenta], [yellow], and [black].
class CmykColor extends cm.CmykColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// A color in the CMYK color space.
  ///
  /// [cyan], [magenta], [yellow], and [black]
  /// must all be `>= 0` and `<= 100`.
  const CmykColor(
    num cyan,
    num magenta,
    num yellow,
    num black, [
    int alpha = 255,
  ])  : assert(cyan >= 0 && cyan <= 100),
        assert(magenta >= 0 && magenta <= 100),
        assert(yellow >= 0 && yellow <= 100),
        assert(black >= 0 && black <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(cyan, magenta, yellow, black, alpha);

  @override
  int get value => toColor().value;

  @override
  CmykColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<CmykColor> lerpTo(
    cm.ColorModel color,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps, excludeOriginalColors: excludeOriginalColors)
        .map<CmykColor>((color) => color.cast())
        .toList();
  }

  @override
  CmykColor get inverted => super.inverted.cast();

  @override
  CmykColor get opposite => super.opposite.cast();

  @override
  CmykColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  CmykColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  CmykColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  CmykColor withCyan(num cyan) {
    assert(cyan >= 0 && cyan <= 100);
    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  @override
  CmykColor withMagenta(num magenta) {
    assert(magenta >= 0 && magenta <= 100);
    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  @override
  CmykColor withYellow(num yellow) {
    assert(yellow >= 0 && yellow <= 100);
    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  @override
  CmykColor withBlack(num black) {
    assert(black >= 0 && black <= 100);
    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  @override
  CmykColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toCmykColor();
  }

  @override
  CmykColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toCmykColor();
  }

  @override
  CmykColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toCmykColor();
  }

  @override
  CmykColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return CmykColor(cyan, magenta, yellow, black, alpha);
  }

  @override
  CmykColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((opacity * 255).round());
  }

  @override
  CmykColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toCmykColor();
  }

  @override
  CmykColor toCmykColor() => this;

  /// Constructs a [CmykColor] from [color].
  factory CmykColor.from(cm.ColorModel color) => color.toCmykColor().cast();

  /// Constructs a [CmykColor] from a list of [cmyk] values.
  ///
  /// [cmyk] must not be null and must have exactly `4` or `5` values.
  ///
  /// Each color value must be `>= 0 && <= 100`.
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

  /// Constructs a [CmykColor] from [color].
  factory CmykColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toCmykColor();

  /// Constructs a [CmykColor] from a RGB [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory CmykColor.fromHex(String hex) => cm.CmykColor.fromHex(hex).cast();

  /// Constructs a [CmykColor] from a list of [cmyk] values
  /// on a `0` to `1` scale.
  ///
  /// [cmyk] must not be null and must have exactly `4` or `5` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory CmykColor.extrapolate(List<double> values) {
    assert(values.length == 4 || values.length == 5);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    assert(values[3] >= 0 && values[3] <= 1);
    if (values.length == 5) assert(values[4] >= 0 && values[4] <= 1);
    final alpha = values.length == 5 ? (values[4] * 255).round() : 255;
    return CmykColor(values[0] * 100, values[1] * 100, values[2] * 100,
        values[3] * 100, alpha);
  }

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
  factory CmykColor.random({
    num minCyan = 0,
    num maxCyan = 100,
    num minMagenta = 0,
    num maxMagenta = 100,
    num minYellow = 0,
    num maxYellow = 100,
    num minBlack = 0,
    num maxBlack = 100,
  }) {
    assert(minCyan >= 0 && minCyan <= maxCyan);
    assert(maxCyan >= minCyan && maxCyan <= 100);
    assert(minMagenta >= 0 && minMagenta <= maxMagenta);
    assert(maxMagenta >= minMagenta && maxMagenta <= 100);
    assert(minYellow >= 0 && minYellow <= maxYellow);
    assert(maxYellow >= minYellow && maxYellow <= 100);
    assert(minBlack >= 0 && minBlack <= maxBlack);
    assert(maxBlack >= minBlack && maxBlack <= 100);

    return cm.CmykColor.random(
      minCyan: minCyan,
      maxCyan: maxCyan,
      minMagenta: minMagenta,
      maxMagenta: maxMagenta,
      minYellow: minYellow,
      maxYellow: maxYellow,
      minBlack: minBlack,
      maxBlack: maxBlack,
    ).cast();
  }

  @override
  CmykColor convert(cm.ColorModel other) => other.toCmykColor().cast();
}
