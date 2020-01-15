import '../color_model.dart';
import '../helpers/color_converter.dart';

/// A color in the HSI color space.
///
/// The HSI color space contains channels for [hue],
/// [saturation], and [intensity].
class HsiColor extends ColorModel {
  /// A color in the HSV (HSB) color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [intensity] must both be `>= 0` and `<= 100`.
  const HsiColor(
    this.hue,
    this.saturation,
    this.intensity,
  )   : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(intensity != null && intensity >= 0 && intensity <= 100);

  /// The hue value of this color.
  ///
  /// Ranges from `0` to `360`.
  final num hue;

  /// The saturation value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num saturation;

  /// The intensity value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num intensity;

  @override
  bool get isWhite => (saturation == 0 && intensity == 100);

  @override
  bool get isBlack => (intensity == 0);

  @override
  RgbColor toRgbColor() => ColorConverter.hsiToRgb(this);

  /// Returns a fixed-length [List] containing the [hue],
  /// [saturation], and [intensity] values in that order.
  @override
  List<num> toList() {
    final list = List<num>(3);

    list[0] = hue;
    list[1] = saturation;
    list[2] = intensity;

    return list;
  }

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [intensity] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List.from(<double>[
        hue / 360,
        saturation / 100,
        intensity / 100,
      ], growable: false);

  /// Parses a list for HSI values and returns a [HsiColor].
  ///
  /// [hsi] must not be null and must have exactly 3 values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and intensity must both be `>= 0` and `<= 100`.
  static HsiColor fromList(List<num> hsi) {
    assert(hsi != null && hsi.length == 3);
    assert(hsi[0] != null && hsi[0] >= 0 && hsi[0] <= 360);
    assert(hsi[1] != null && hsi[1] >= 0 && hsi[1] <= 100);
    assert(hsi[2] != null && hsi[2] >= 0 && hsi[2] <= 100);

    return HsiColor(hsi[0], hsi[1], hsi[2]);
  }

  /// Returns a [color] from another color space as a HSI color.
  static HsiColor from(ColorModel color) {
    assert(color != null);

    return color.toHsiColor();
  }

  /// Returns a [HsiColor] from a list of [hsi] values on a 0 to 1 scale.
  ///
  /// [hsi] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static HsiColor extrapolate(List<double> hsi) {
    assert(hsi != null && hsi.length == 3);
    assert(hsi[0] != null && hsi[0] >= 0 && hsi[0] <= 1);
    assert(hsi[1] != null && hsi[1] >= 0 && hsi[1] <= 1);
    assert(hsi[2] != null && hsi[2] >= 0 && hsi[2] <= 1);

    return HsiColor(hsi[0] * 360, hsi[1] * 100, hsi[2] * 100);
  }

  @override
  bool operator ==(Object o) =>
      o is HsiColor &&
      hue == o.hue &&
      saturation == o.saturation &&
      intensity == o.intensity;

  @override
  int get hashCode => hue.hashCode ^ saturation.hashCode ^ intensity.hashCode;
}
