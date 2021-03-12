import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// A color in the CIEXYZ color space.
class XyzColor extends cm.XyzColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// A color in the CIEXYZ color space.
  ///
  /// [x], [y], and [z] must all be `>= 0`.
  ///
  /// The XYZ values have been normalized to a 0 to 100 range that
  /// represents the whole of the sRGB color space, but have been
  /// left upwardly unbounded to allow to allow for conversions
  /// between the XYZ and LAB color spaces that fall outside of
  /// the sRGB color space's bounds.
  const XyzColor(
    num x,
    num y,
    num z, [
    int alpha = 255,
  ])  : assert(x >= 0),
        assert(y >= 0),
        assert(z >= 0),
        assert(alpha >= 0 && alpha <= 255),
        super(x, y, z, alpha);

  @override
  int get value => toColor().value;

  @override
  List<XyzColor> lerpTo(
    cm.ColorModel color,
    int steps, {
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps, excludeOriginalColors: excludeOriginalColors)
        .map<XyzColor>((color) => color.cast())
        .toList();
  }

  @override
  XyzColor get inverted => super.inverted.cast();

  @override
  XyzColor get opposite => super.opposite.cast();

  @override
  XyzColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  XyzColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  XyzColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  XyzColor withX(num x) {
    assert(x >= 0);
    return XyzColor(x, y, z, alpha);
  }

  @override
  XyzColor withY(num y) {
    assert(y >= 0);
    return XyzColor(x, y, z, alpha);
  }

  @override
  XyzColor withZ(num z) {
    assert(z >= 0);
    return XyzColor(x, y, z, alpha);
  }

  @override
  XyzColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toXyzColor();
  }

  @override
  XyzColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toXyzColor();
  }

  @override
  XyzColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toXyzColor();
  }

  @override
  XyzColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return XyzColor(x, y, z, alpha);
  }

  @override
  XyzColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((opacity * 255).round());
  }

  /// Returns this [XyzColor] modified with the provided [hue] value.
  @override
  XyzColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    final hslColor = toHslColor();
    return hslColor.withHue((hslColor.hue + hue) % 360).toXyzColor();
  }

  @override
  XyzColor toXyzColor() => this;

  /// Constructs a [XyzColor] from [color].
  factory XyzColor.from(cm.ColorModel color) => color.toXyzColor().cast();

  /// Constructs a [XyzColor] from a list of [xyz] values.
  ///
  /// [xyz] must not be null and must have exactly `3` or `4` values.
  ///
  /// [x] must be `>= 0` and `<= 95`.
  ///
  /// [y] must be `>= 0` and `<= 100`.
  ///
  /// [z] must be `>= 0` and `<= 109`.
  ///
  /// None of the color values may be null.
  factory XyzColor.fromList(List<num> xyz) {
    assert(xyz.length == 3 || xyz.length == 4);
    assert(xyz[0] >= 0 && xyz[0] <= 100);
    assert(xyz[1] >= 0 && xyz[1] <= 100);
    assert(xyz[2] >= 0 && xyz[2] <= 100);
    if (xyz.length == 4) assert(xyz[3] >= 0 && xyz[3] <= 255);
    final alpha = xyz.length == 4 ? xyz[3].round() : 255;
    return XyzColor(xyz[0], xyz[1], xyz[2], alpha);
  }

  /// Constructs a [XyzColor] from [color].
  factory XyzColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toXyzColor();

  /// Constructs a [XyzColor] from a [hex] color.
  ///
  /// [hex] is case-insensitive and must be `3` or `6` characters
  /// in length, excluding an optional leading `#`.
  factory XyzColor.fromHex(String hex) => cm.XyzColor.fromHex(hex).cast();

  /// Constructs a [XyzColor] from a list of [xyz] values on a `0` to `1` scale.
  ///
  /// [xyz] must not be null and must have exactly `3` or `4` values.
  ///
  /// Each of the values must be `>= 0` and `<= 1`.
  factory XyzColor.extrapolate(List<double> xyz) {
    assert(xyz.length == 3 || xyz.length == 4);
    assert(xyz[0] >= 0 && xyz[0] <= 1);
    assert(xyz[1] >= 0 && xyz[1] <= 1);
    assert(xyz[2] >= 0 && xyz[2] <= 1);
    if (xyz.length == 4) assert(xyz[3] >= 0 && xyz[3] <= 1);
    final alpha = xyz.length == 4 ? (xyz[3] * 255).round() : 255;
    return XyzColor(xyz[0] * 100, xyz[1] * 100, xyz[2] * 100, alpha);
  }

  /// Generates a [XyzColor] at random.
  ///
  /// [minX] and [maxX] constrain the generated [x] value.
  ///
  /// [minY] and [maxY] constrain the generated [y] value.
  ///
  /// [minZ] and [maxZ] constrain the generated [z] value.
  ///
  /// All min and max values must be `min <= max && max >= min`, must be
  /// in the range of `>= 0 && <= 100`, and must not be `null`.
  factory XyzColor.random({
    num minX = 0,
    num maxX = 100,
    num minY = 0,
    num maxY = 100,
    num minZ = 0,
    num maxZ = 100,
  }) {
    assert(minX >= 0 && minX <= maxX);
    assert(maxX >= minX && maxX <= 100);
    assert(minY >= 0 && minY <= maxY);
    assert(maxY >= minY && maxY <= 100);
    assert(minZ >= 0 && minZ <= maxZ);
    assert(maxZ >= minZ && maxZ <= 100);
    return cm.XyzColor.random(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      minZ: minZ,
      maxZ: maxZ,
    ).cast();
  }
}
