import 'dart:math' show Random;
import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_adjustments.dart';
import '../helpers/color_converter.dart';

/// A color in the sRGB color space.
///
/// The sRGB color space contains channels for [red], [green], and [blue].
///
/// [RgbColor] stores RGB values as [num]s privately in order to avoid
/// a loss of precision when converting between color spaces, but has
/// getters set for [red], [green], and [blue] that return the rounded
/// [int] values. The precise values can returned as a list with the
/// `toPreciseList()` method.
@immutable
class RgbColor extends ColorModel {
  /// A color in the sRGB color space.
  ///
  /// [red], [green], and [blue] must all be `>= 0` and `<= 255`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  const RgbColor(
    num red,
    num green,
    num blue, [
    int alpha = 255,
  ])  : assert(red >= 0 && red <= 255),
        assert(green >= 0 && green <= 255),
        assert(blue >= 0 && blue <= 255),
        assert(alpha >= 0 && alpha <= 255),
        _red = red,
        _green = green,
        _blue = blue,
        super(alpha: alpha);

  /// The red value of this color.
  ///
  /// Ranges from `0` to `255`.
  int get red => _red.round();
  final num _red;

  /// The green value of this color.
  ///
  /// Ranges from `0` to `255`.
  int get green => _green.round();
  final num _green;

  /// The blue value of this color.
  ///
  /// Ranges from `0` to `255`.
  int get blue => _blue.round();
  final num _blue;

  @override
  bool get isBlack => red == 0 && green == 0 && blue == 0;

  @override
  bool get isWhite => red == 255 && green == 255 && blue == 255;

  @override
  bool get isMonochromatic => red == green && red == blue;

  @override
  RgbColor interpolate(ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step) as RgbColor;
  }

  @override
  List<RgbColor> lerpTo(
    ColorModel color,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps, excludeOriginalColors: excludeOriginalColors)
        .cast<RgbColor>();
  }

  @override
  RgbColor get inverted {
    final values = toPreciseList();

    return RgbColor.fromList(
        List<num>.generate(values.length, (i) => 255 - values[i])..add(alpha));
  }

  @override
  RgbColor get opposite => rotateHue(180);

  @override
  RgbColor rotateHue(num amount) =>
      ColorAdjustments.rotateHue(this, amount).toRgbColor();

  @override
  RgbColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    if (relative) assert(amount <= 100);
    return ColorAdjustments.warmer(this, amount, relative: relative)
        .toRgbColor();
  }

  @override
  RgbColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    if (relative) assert(amount <= 100);
    return ColorAdjustments.cooler(this, amount, relative: relative)
        .toRgbColor();
  }

  /// Returns this [RgbColor] modified with the provided [red] value.
  RgbColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return RgbColor(red, green, blue, alpha);
  }

  /// Returns this [RgbColor] modified with the provided [green] value.
  RgbColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return RgbColor(red, green, blue, alpha);
  }

  /// Returns this [RgbColor] modified with the provided [blue] value.
  RgbColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return RgbColor(red, green, blue, alpha);
  }

  /// Returns this [RgbColor] modified with the provided [alpha] value.
  @override
  RgbColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return RgbColor(red, green, blue, alpha);
  }

  @override
  RgbColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((opacity * 255).round());
  }

  /// Returns this [RgbColor] modified with the provided [hue] value.
  @override
  RgbColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toRgbColor();
  }

  @override
  RgbColor toRgbColor() => this;

  /// Returns a fixed-length list containing the
  /// [red], [green], and [blue] values.
  @override
  List<int> toList() =>
      List<int>.from(<int>[red, green, blue], growable: false);

  /// Returns a fixed-length list containing the
  /// [red], [green], [blue], and [alpha] values.
  @override
  List<num> toListWithAlpha() =>
      List<num>.from(<num>[red, green, blue, alpha], growable: false);

  /// Returns a fixed-length list containing the precise
  /// [red], [green], and [blue] values.
  List<num> toPreciseList() =>
      List<num>.from(<num>[_red, _green, _blue], growable: false);

  /// Returns a fixed-length list containing the precise
  /// [red], [green], [blue], and [alpha] values.
  List<num> toPreciseListWithAlpha() =>
      List<num>.from(<num>[_red, _green, _blue, alpha], growable: false);

  /// Returns a fixed-length list containing the [red], [green],
  /// and [blue] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() =>
      toPreciseList().map((rgbValue) => rgbValue / 255).toList(growable: false);

  /// Returns a fixed-length list containing the [red], [green],
  /// [blue], and [alpha] values factored to be on 0 to 1 scale.
  List<double> toFactoredListWithAlpha() => List<double>.from(<double>[
        _red / 255,
        _green / 255,
        _blue / 255,
        alpha / 255,
      ], growable: false);

  /// Constructs a [RgbColor] from [color].
  factory RgbColor.from(ColorModel color) => color.toRgbColor();

  /// Constructs a [RgbColor] from a list of [rgb] values.
  ///
  /// [rgb] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each color value must be `>= 0 && <= 255`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 255`.
  factory RgbColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 255);
    assert(values[1] >= 0 && values[1] <= 255);
    assert(values[2] >= 0 && values[2] <= 255);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return RgbColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [RgbColor] from a RGB [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory RgbColor.fromHex(String hex) => ColorConverter.hexToRgb(hex);

  /// Constructs a [RgbColor] from a list of [rgb] values on a `0` to `1` scale.
  ///
  /// [rgb] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory RgbColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    final red = _extrapolate(values[0]);
    final green = _extrapolate(values[1]);
    final blue = _extrapolate(values[2]);
    return RgbColor(red, green, blue, alpha);
  }

  /// Extrapolates [value] from a `0` to `1` scale to a `0` to `255` scale.
  static num _extrapolate(num value) {
    if (1 - value < 0.000001) value = 1;
    return value * 255;
  }

  /// Generates a [RgbColor] at random.
  ///
  /// [minRed] and [maxRed] constrain the generated [red] value.
  ///
  /// [minGreen] and [maxGreen] constrain the generated [green] value.
  ///
  /// [minBlue] and [maxBlue] constrain the generated [blue] value.
  ///
  /// All min and max values must be `min <= max && max >= min` and
  /// must be in the range of `>= 0 && <= 255`.
  factory RgbColor.random({
    int minRed = 0,
    int maxRed = 255,
    int minGreen = 0,
    int maxGreen = 255,
    int minBlue = 0,
    int maxBlue = 255,
  }) {
    assert(minRed >= 0 && minRed <= maxRed);
    assert(maxRed >= minRed && maxRed <= 255);
    assert(minGreen >= 0 && minGreen <= maxGreen);
    assert(maxGreen >= minGreen && maxGreen <= 255);
    assert(minBlue >= 0 && minBlue <= maxBlue);
    assert(maxBlue >= minBlue && maxBlue <= 255);
    return RgbColor(
      _random(minRed, maxRed),
      _random(minGreen, maxGreen),
      _random(minBlue, maxBlue),
    );
  }

  /// Generates a random integer between [min] and [max].
  static int _random(int min, int max) {
    assert(min >= 0 && min <= max);
    assert(max >= min && max <= 255);
    return Random().nextInt(max + 1 - min) + min;
  }

  @override
  RgbColor convert(ColorModel other) => other.toRgbColor();

  @override
  String toString() => 'RgbColor($red, $green, $blue, $alpha)';

  @override
  bool operator ==(Object other) =>
      other is RgbColor &&
      red == other.red &&
      green == other.green &&
      blue == other.blue &&
      alpha == other.alpha;

  @override
  int get hashCode =>
      red.hashCode ^ green.hashCode ^ blue.hashCode ^ alpha.hashCode;
}
