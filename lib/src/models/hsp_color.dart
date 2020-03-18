import 'package:meta/meta.dart';
import '../color_model.dart';
import '../helpers/color_converter.dart';

/// A color in the HSP color space.
///
/// The HSP color space contains channels for [hue],
/// [saturation], and [perceivedBrightness].
///
/// The HSP color space was created in 2006 by Darel Rex Finley.
/// Read about it here: http://alienryderflex.com/hsp.html
@immutable
class HspColor extends ColorModel {
  /// A color in the HSP color space.
  ///
  /// [hue] must be `>= 0` and `<= 360`.
  ///
  /// [saturation] and [perceivedBrightness] must both be `>= 0` and `<= 100`.
  ///
  /// [alpha] must be `>= 0` and `<= 1`.
  const HspColor(
    this.hue,
    this.saturation,
    this.perceivedBrightness, [
    this.alpha = 1.0,
  ])  : assert(hue != null && hue >= 0 && hue <= 360),
        assert(saturation != null && saturation >= 0 && saturation <= 100),
        assert(perceivedBrightness != null &&
            perceivedBrightness >= 0 &&
            perceivedBrightness <= 100),
        assert(alpha != null && alpha >= 0 && alpha <= 1);

  /// The hue value of this color.
  ///
  /// Ranges from `0` to `360`.
  final num hue;

  /// The saturation value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num saturation;

  /// Thie perceived brightness value of this color.
  ///
  /// Ranges from `0` to `100`.
  final num perceivedBrightness;

  @override
  final num alpha;

  @override
  bool get isBlack => (perceivedBrightness == 0);

  @override
  bool get isWhite => (perceivedBrightness == 1);

  @override
  RgbColor toRgbColor() => ColorConverter.hspToRgb(this);

  /// Returns a fixed-length [List] containing the [hue], [saturation],
  /// and [perceivedBrightness] values in that order.
  @override
  List<num> toList() {
    final list = List<num>(3);

    list[0] = hue;
    list[1] = saturation;
    list[2] = perceivedBrightness;

    return list;
  }

  /// Returns a fixed-length list containing the [hue], [saturation],
  /// and [perceivedBrightness] values factored to be on 0 to 1 scale.
  List<double> toFactoredList() => List.from(<double>[
        hue / 360,
        saturation / 100,
        perceivedBrightness / 100,
      ], growable: false);

  /// Parses a list for HSP values and returns a [HspColor].
  ///
  /// [hsp] must not be null and must have exactly 3 values.
  ///
  /// The hue must be `>= 0` and `<= 360`.
  ///
  /// The saturation and perceived brightness must both be `>= 0` and `<= 100`.
  static HspColor fromList(List<num> hsp) {
    assert(hsp != null && hsp.length == 3);
    assert(hsp[0] != null && hsp[0] >= 0 && hsp[0] <= 360);
    assert(hsp[1] != null && hsp[1] >= 0 && hsp[1] <= 100);
    assert(hsp[2] != null && hsp[2] >= 0 && hsp[2] <= 100);

    return HspColor(hsp[0], hsp[1], hsp[2]);
  }

  /// Returns a [color] in another color space as a HSP color.
  static HspColor from(ColorModel color) {
    assert(color != null);

    return color.toHspColor();
  }

  /// Returns a [hex] color as a HSP color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  static HspColor fromHex(String hex) {
    assert(hex != null);

    return ColorConverter.hexToRgb(hex).toHspColor();
  }

  /// Returns a [HspColor] from a list of [hsp] values on a 0 to 1 scale.
  ///
  /// [hsp] must not be null and must have exactly 3 values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  static HspColor extrapolate(List<double> hsp) {
    assert(hsp != null && hsp.length == 3);
    assert(hsp[0] != null && hsp[0] >= 0 && hsp[0] <= 1);
    assert(hsp[1] != null && hsp[1] >= 0 && hsp[1] <= 1);
    assert(hsp[2] != null && hsp[2] >= 0 && hsp[2] <= 1);

    return HspColor(hsp[0] * 360, hsp[1] * 100, hsp[2] * 100);
  }

  @override
  String toString() => 'HspColor($hue, $saturation, $perceivedBrightness)';

  @override
  bool operator ==(Object o) =>
      o is HspColor &&
      hue == o.hue &&
      saturation == o.saturation &&
      perceivedBrightness == o.perceivedBrightness;

  @override
  int get hashCode =>
      hue.hashCode ^ saturation.hashCode ^ perceivedBrightness.hashCode;
}
