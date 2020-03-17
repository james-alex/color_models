import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_converter.dart';

/// A color in the HSV (HSB) color space.
///
/// The HSV color space contains channels for [hue],
/// [saturation], and [value].
@immutable
class HsvColor extends ColorModel {
  /// A color in the HSV (HSB) color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [value] must both be `>= 0` and `<= 100`.
  HsvColor(
    this.hue,
    this.saturation,
    this.value,
  )   : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(value != null && value >= 0 && value <= 100);

  /// The hue value of this color.
  ///
  /// Ranges from `0 to 360`.
  final num hue;

  /// The saturation value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num saturation;

  /// The value (brightness) value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num value;

  @override
  bool get isBlack => (value == 0);

  @override
  bool get isWhite => (saturation == 0 && value == 1);

  @override
  RgbColor toRgbColor() => ColorConverter.hsvToRgb(this);

  /// Returns a fixed-length [List] containing the [hue],
  /// [saturation], and [value] values in that order.
  @override
  List<num> toList() {
    final list = List<num>(3);

    list[0] = hue;
    list[1] = saturation;
    list[2] = value;

    return list;
  }

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [value] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List.from(<double>[
        hue / 360,
        saturation / 100,
        value / 100,
      ], growable: false);

  /// Parses a list for HSV values and returns a [HsvColor].
  ///
  /// [hsv] must not be null and must have exactly 3 values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and value must both be `>= 0` and `<= 100`.
  static HsvColor fromList(List<num> hsv) {
    assert(hsv != null && hsv.length == 3);
    assert(hsv[0] != null && hsv[0] >= 0 && hsv[0] <= 360);
    assert(hsv[1] != null && hsv[1] >= 0 && hsv[1] <= 100);
    assert(hsv[2] != null && hsv[2] >= 0 && hsv[2] <= 100);

    return HsvColor(hsv[0], hsv[1], hsv[2]);
  }

  /// Returns a [color] in another color space as a HSV color.
  static HsvColor from(ColorModel color) {
    assert(color != null);

    return color.toHsvColor();
  }

  /// Returns a [hex] color as a HSV color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  static HsvColor fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toHsvColor();
  }

  /// Returns a [HsvColor] from a list of [hsv] values on a 0 to 1 scale.
  ///
  /// [hsv] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static HsvColor extrapolate(List<double> hsv) {
    assert(hsv != null && hsv.length == 3);
    assert(hsv[0] != null && hsv[0] >= 0 && hsv[0] <= 1);
    assert(hsv[1] != null && hsv[1] >= 0 && hsv[1] <= 1);
    assert(hsv[2] != null && hsv[2] >= 0 && hsv[2] <= 1);

    return HsvColor(hsv[0] * 360, hsv[1] * 100, hsv[2] * 100);
  }

  @override
  String toString() => 'HsvColor($hue, $saturation, $value)';

  @override
  bool operator ==(Object o) =>
      o is HsvColor &&
      hue == o.hue &&
      saturation == o.saturation &&
      value == o.value;

  @override
  int get hashCode => hue.hashCode ^ saturation.hashCode ^ value.hashCode;
}
