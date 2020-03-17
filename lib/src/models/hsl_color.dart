import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_converter.dart';

/// A color in the HSL color space.
///
/// The HSL color space contains channels for [hue],
/// [saturation], and [lightness].
@immutable
class HslColor extends ColorModel {
  /// A color in the HSL color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [lightness] must both be `>= 0` and `<= 100`.
  const HslColor(
    this.hue,
    this.saturation,
    this.lightness,
  )   : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(lightness != null && lightness >= 0 && lightness <= 100);

  /// The hue value of this color ranging from 0 to 360.
  final num hue;

  /// The saturation value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num saturation;

  /// The lightness value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num lightness;

  @override
  bool get isBlack => (lightness == 0);

  @override
  bool get isWhite => (lightness == 100);

  @override
  RgbColor toRgbColor() => ColorConverter.hslToRgb(this);

  /// Returns a fixed-length [List] containing the [hue],
  /// [saturation], and [lightness] values in that order.
  @override
  List<num> toList() {
    final list = List<num>(3);

    list[0] = hue;
    list[1] = saturation;
    list[2] = lightness;

    return list;
  }

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [lightness] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List.from(<double>[
        hue / 360,
        saturation / 100,
        lightness / 100,
      ], growable: false);

  /// Parses a list for HSL values and returns a [HslColor].
  ///
  /// [hsl] must not be null and must have exactly 3 values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and lightness must both be `>= 0` and `<= 100`.
  static HslColor fromList(List<num> hsl) {
    assert(hsl != null && hsl.length == 3);
    assert(hsl[0] != null && hsl[0] >= 0 && hsl[0] <= 360);
    assert(hsl[1] != null && hsl[1] >= 0 && hsl[1] <= 100);
    assert(hsl[2] != null && hsl[2] >= 0 && hsl[2] <= 100);

    return HslColor(hsl[0], hsl[1], hsl[2]);
  }

  /// Returns a [color] in another color space as a HSL color.
  static HslColor from(ColorModel color) {
    assert(color != null);

    return color.toHslColor();
  }

  /// Returns a [hex] color as a HSL color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  static HslColor fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toHslColor();
  }

  /// Returns a [HslColor] from a list of [hsl] values on a 0 to 1 scale.
  ///
  /// [hsl] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static HslColor extrapolate(List<double> hsl) {
    assert(hsl != null && hsl.length == 3);
    assert(hsl[0] != null && hsl[0] >= 0 && hsl[0] <= 1);
    assert(hsl[1] != null && hsl[1] >= 0 && hsl[1] <= 1);
    assert(hsl[2] != null && hsl[2] >= 0 && hsl[2] <= 1);

    return HslColor(hsl[0] * 360, hsl[1] * 100, hsl[2] * 100);
  }

  @override
  String toString() => 'HslColor($hue, $saturation, $lightness)';

  @override
  bool operator ==(Object o) =>
      o is HslColor &&
      hue == o.hue &&
      saturation == o.saturation &&
      lightness == o.lightness;

  @override
  int get hashCode => hue.hashCode ^ saturation.hashCode ^ lightness.hashCode;
}
