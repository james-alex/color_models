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
    this.alpha = 1.0,
  ])  : assert(red != null && red >= 0 && red <= 255),
        assert(green != null && green >= 0 && green <= 255),
        assert(blue != null && blue >= 0 && blue <= 255),
        assert(alpha != null && alpha >= 0 && alpha <= 1),
        _red = red,
        _green = green,
        _blue = blue;

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
  final num alpha;

  @override
  bool get isBlack => (red == 0 && green == 0 && blue == 0);

  @override
  bool get isWhite => (red == 255 && green == 255 && blue == 255);

  @override
  RgbColor get inverted {
    final values = toList();

    return RgbColor.fromList(
        List<num>.generate(values.length, (i) => 255 - values[i])..add(alpha));
  }

  @override
  RgbColor rotateHue(num amount) {
    assert(amount != null);

    return ColorAdjustments.rotateHue(this, amount).toRgbColor();
  }

  @override
  RgbColor warmer(num amount) {
    assert(amount != null && amount > 0);

    return ColorAdjustments.warmer(this, amount).toRgbColor();
  }

  @override
  RgbColor cooler(num amount) {
    assert(amount != null && amount > 0);

    return ColorAdjustments.cooler(this, amount).toRgbColor();
  }

  /// Returns this [RgbColor] modified with the provided [red] value.
  RgbColor withRed(num red) {
    assert(red != null && red >= 0 && red <= 255);

    return RgbColor(red, green, blue, alpha);
  }

  /// Returns this [RgbColor] modified with the provided [green] value.
  RgbColor withGreen(num green) {
    assert(green != null && green >= 0 && green <= 255);

    return RgbColor(red, green, blue, alpha);
  }

  /// Returns this [RgbColor] modified with the provided [blue] value.
  RgbColor withBlue(num blue) {
    assert(blue != null && blue >= 0 && blue <= 255);

    return RgbColor(red, green, blue, alpha);
  }

  /// Returns this [RgbColor] modified with the provided [alpha] value.
  @override
  RgbColor withAlpha(num alpha) {
    assert(alpha != null && alpha >= 0 && alpha <= 1);

    return RgbColor(red, green, blue, alpha);
  }

  /// Returns this [RgbColor] modified with the provided [hue] value.
  @override
  RgbColor withHue(num hue) {
    assert(hue != null && hue >= 0 && hue <= 360);

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
  List<double> toFactoredListWithAlpha() => List<num>.from(<num>[
        _red / 255,
        _green / 255,
        _blue / 255,
        alpha,
      ], growable: false);

  /// Parses a list for RGB values and returns a [RgbColor].
  ///
  /// [rgb] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each color value must be `>= 0 && <= 255`.
  ///
  /// The [alpha] value, if included, must be `>= 0 && <= 1`.
  static RgbColor fromList(List<num> rgb) {
    assert(rgb != null && (rgb.length == 3 || rgb.length == 4));
    assert(rgb[0] != null && rgb[0] >= 0 && rgb[0] <= 255);
    assert(rgb[1] != null && rgb[1] >= 0 && rgb[1] <= 255);
    assert(rgb[2] != null && rgb[2] >= 0 && rgb[2] <= 255);
    if (rgb.length == 4) {
      assert(rgb[3] != null && rgb[3] >= 0 && rgb[3] <= 1);
    }

    final alpha = rgb.length == 4 ? rgb[3] : 1.0;

    return RgbColor(rgb[0], rgb[1], rgb[2], alpha);
  }

  /// Returns a [color] in another color space as a RGB color.
  static RgbColor from(ColorModel color) {
    assert(color != null);

    return color.toRgbColor();
  }

  /// Returns a [hex] color as a RGB color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  static RgbColor fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex);
  }

  /// Returns a [RgbColor] from a list of [rgb] values on a 0 to 1 scale.
  ///
  /// [rgb] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static RgbColor extrapolate(List<double> rgb) {
    assert(rgb != null && (rgb.length == 3 || rgb.length == 4));
    assert(rgb[0] != null && rgb[0] >= 0 && rgb[0] <= 1);
    assert(rgb[1] != null && rgb[1] >= 0 && rgb[1] <= 1);
    assert(rgb[2] != null && rgb[2] >= 0 && rgb[2] <= 1);
    if (rgb.length == 4) {
      assert(rgb[3] != null && rgb[3] >= 0 && rgb[3] <= 1);
    }

    final alpha = rgb.length == 4 ? rgb[3] : 1.0;

    return RgbColor(rgb[0] * 255, rgb[1] * 255, rgb[2] * 255, alpha);
  }

  @override
  String toString() => 'RgbColor($red, $green, $blue)';

  @override
  bool operator ==(Object o) =>
      o is RgbColor && red == o.red && green == o.green && blue == o.blue;

  @override
  int get hashCode => red.hashCode ^ green.hashCode ^ blue.hashCode;
}
