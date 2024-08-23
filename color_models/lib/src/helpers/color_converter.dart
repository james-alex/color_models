/// The CMYK to/from RGB conversion algorithms were adapted from:
/// https://gist.github.com/felipesabino/5066336
///
/// The HSI, XYZ, and XYZ to LAB conversion algorithms were adapted from:
/// https://github.com/colorjs/color-space/
///
/// The LAB to XYZ conversion algorithm was adapted from:
/// https://stackoverflow.com/questions/46627367/convert-lab-to-xyz
///
/// The Oklab to RGB conversion algorithm was adapted from:
/// https://bottosson.github.io/posts/oklab/
///
/// The HSL and HSB conversion algorithms were adapted from:
/// http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
///
/// The HSP conversion algorithms were adapted from:
/// http://alienryderflex.com/hsp.html

import 'dart:math' as math;
import 'package:powers/powers.dart';
import '../color_model.dart';

/// A utility class with color conversion methods to and
/// from RGB for each color model included in this package.
class ColorConverter {
  ColorConverter._();

  /// Returns a [hex] color as a RGB color.
  static RgbColor hexToRgb(String hex) {
    hex = hex.replaceFirst('#', '').toLowerCase();

    assert(hex.length == 3 || hex.length == 6);
    assert(hex.split('').every((c) => RegExp(r'[a-f0-9]').hasMatch(c)));

    var rgb = hex.split('');

    if (rgb.length == 3) {
      rgb = <String>[rgb[0], rgb[0], rgb[1], rgb[1], rgb[2], rgb[2]];
    }

    final red = int.parse('0x${rgb[0]}${rgb[1]}');
    final green = int.parse('0x${rgb[2]}${rgb[3]}');
    final blue = int.parse('0x${rgb[4]}${rgb[5]}');

    return RgbColor(red, green, blue);
  }

  /// Converts a color from any color space to CMYK.
  static CmykColor toCmykColor(ColorModel color) =>
      rgbToCmyk(color.toRgbColor());

  /// Converts a RGB color to a CMYK color.
  static CmykColor rgbToCmyk(RgbColor rgbColor) {
    final rgb = rgbColor.toFactoredList();

    final cmy = rgb.map((rgbValue) => 1 - rgbValue).toList();
    final k = cmy.reduce(math.min).clamp(0.0, 1.0);
    final alpha = rgbColor.alpha / 255;

    final cmyk = cmy
        .map((cmyValue) => ((cmyValue - k) / (1 - k)).clamp(0.0, 1.0))
        .toList()
      ..add(k)
      ..add(alpha);

    return CmykColor.extrapolate(List<double>.from(cmyk));
  }

  /// Converts a CMYK color to a RGB color.
  static RgbColor cmykToRgb(CmykColor cmykColor) {
    final cmyk = cmykColor.toFactoredList();

    final cmy = cmyk.sublist(0, 3);
    final k = cmyk.last;
    final alpha = cmykColor.alpha / 255;

    final rgb = cmy
        .map(
            (cmyValue) => 1 - ((cmyValue * (1 - k)) + k).clamp(0, 1).toDouble())
        .toList()
      ..add(alpha);

    return RgbColor.extrapolate(rgb);
  }

  /// Converts a color from any color space to HSI.
  static HsiColor toHsiColor(ColorModel color) => rgbToHsi(color.toRgbColor());

  /// Converts a RGB color to a HSI color.
  static HsiColor rgbToHsi(RgbColor rgbColor) {
    if (rgbColor.isBlack) return HsiColor(0, 0, 0, rgbColor.alpha);
    if (rgbColor.isWhite) return HsiColor(0, 0, 100, rgbColor.alpha);
    if (rgbColor.isMonochromatic) {
      return HsiColor(0, 0, rgbColor.red / 255 * 100, rgbColor.alpha);
    }

    final rgb = rgbColor.toPreciseList();
    final sum = rgb.reduce((a, b) => a + b);
    final red = rgb[0] / sum;
    final green = rgb[1] / sum;
    final blue = rgb[2] / sum;

    var hue = math.acos((0.5 * ((red - green) + (red - blue))) /
        math.sqrt(
            ((red - green) * (red - green)) + ((red - blue) * (green - blue))));

    if (blue > green) hue = (2 * math.pi) - hue;

    if (hue.isNaN) {
      // Achromatic
      hue = 0;
    } else {
      hue /= math.pi * 2;
    }

    final min = <double>[red, green, blue].reduce(math.min);
    final saturation = 1 - 3 * min;
    final intensity = sum / 3 / 255;
    final alpha = rgbColor.alpha / 255;

    return HsiColor.extrapolate(<double>[hue, saturation, intensity, alpha]);
  }

  /// Converts a HSI color to a RGB color.
  static RgbColor hsiToRgb(HsiColor hsiColor) {
    final hsi = hsiColor.toFactoredList();

    var hue = hsi[0] * math.pi * 2;
    final saturation = hsi[1];
    final intensity = hsi[2];

    final pi3 = math.pi / 3;

    double red, green, blue;

    final firstValue = intensity * (1 - saturation);

    double calculateSecondValue(double hue) =>
        intensity * (1 + (saturation * math.cos(hue) / math.cos(pi3 - hue)));

    double calculateThirdValue(double hue) =>
        intensity *
        (1 + (saturation * (1 - (math.cos(hue) / math.cos(pi3 - hue)))));

    if (hue < 2 * pi3) {
      blue = firstValue;
      red = calculateSecondValue(hue);
      green = calculateThirdValue(hue);
    } else if (hue < 4 * pi3) {
      hue = hue - (2 * pi3);
      red = firstValue;
      green = calculateSecondValue(hue);
      blue = calculateThirdValue(hue);
    } else {
      hue = hue - (4 * pi3);
      green = firstValue;
      blue = calculateSecondValue(hue);
      red = calculateThirdValue(hue);
    }

    // The calculated RGB values, in some cases, may
    // exceed 1.0 by up to 0.0000000000000002.
    if (red > 1) red = 1;
    if (green > 1) green = 1;
    if (blue > 1) blue = 1;

    final alpha = hsiColor.alpha / 255;

    return RgbColor.extrapolate(<double>[red, green, blue, alpha]);
  }

  /// Converts a color from any color space to HSL.
  static HslColor toHslColor(ColorModel color) => rgbToHsl(color.toRgbColor());

  /// Converts a RGB color to a HSL color.
  static HslColor rgbToHsl(RgbColor rgbColor) {
    if (rgbColor.isBlack) return HslColor(0, 0, 0, rgbColor.alpha);
    if (rgbColor.isWhite) return HslColor(0, 0, 100, rgbColor.alpha);
    if (rgbColor.isMonochromatic) {
      return HslColor(0, 0, rgbColor.red / 255 * 100, rgbColor.alpha);
    }

    final rgb = rgbColor.toFactoredList();

    final max = rgb.reduce(math.max);
    final min = rgb.reduce(math.min);
    final difference = max - min;

    final lightness = (max + min) / 2;
    final saturation = (lightness > 0.5)
        ? difference / (2 - max - min)
        : difference / (max + min);
    final alpha = rgbColor.alpha / 255;

    return HslColor.extrapolate(
        <double>[getHue(rgbColor), saturation, lightness, alpha]);
  }

  /// Converts a HSL color to a RGB color.
  static RgbColor hslToRgb(HslColor hslColor) {
    final hsl = hslColor.toFactoredList();

    final hue = hsl[0];
    final saturation = hsl[1];
    final lightness = hsl[2];

    double red, green, blue;

    if (saturation == 0) {
      red = green = blue = lightness;
    } else {
      final q = (lightness < 0.5)
          ? lightness * (1 + saturation)
          : lightness + saturation - (lightness * saturation);

      final p = (2 * lightness) - q;

      double hueToRgb(t) {
        if (t < 0) {
          t += 1;
        } else if (t > 1) {
          t -= 1;
        }

        if (t < 1 / 6) return p + ((q - p) * 6 * t);
        if (t < 1 / 2) return q;
        if (t < 2 / 3) return p + ((q - p) * ((2 / 3) - t) * 6);

        return p;
      }

      red = hueToRgb(hue + (1 / 3));
      green = hueToRgb(hue);
      blue = hueToRgb(hue - (1 / 3));
    }

    final alpha = hslColor.alpha / 255;

    return RgbColor.extrapolate(<double>[red, green, blue, alpha]);
  }

  /// Converts a color from any color space to HSL.
  static HspColor toHspColor(ColorModel color) => rgbToHsp(color.toRgbColor());

  /// Converts a RGB color to a HSP color.
  static HspColor rgbToHsp(RgbColor rgbColor) {
    if (rgbColor.isBlack) return HspColor(0, 0, 0, rgbColor.alpha);
    if (rgbColor.isWhite) return HspColor(0, 0, 100, rgbColor.alpha);
    if (rgbColor.isMonochromatic) {
      return HspColor(0, 0, rgbColor.red / 255 * 100, rgbColor.alpha);
    }

    final rgb = rgbColor.toFactoredList();

    final red = rgb[0];
    final green = rgb[1];
    final blue = rgb[2];

    final percievedBrightness = math
        .sqrt((red * red * _pr) + (green * green * _pg) + (blue * blue * _pb));

    final max = rgb.reduce(math.max);
    final min = rgb.reduce(math.min);

    double? hue;
    late double saturation;

    if (max == min) {
      hue = 0;
      saturation = 0;
    } else if (max == red) {
      saturation = 1 - ((blue >= green) ? green / red : blue / red);
    } else if (max == green) {
      saturation = 1 - ((red >= blue) ? blue / green : red / green);
    } else {
      saturation = 1 - ((green >= red) ? red / blue : green / blue);
    }

    hue ??= getHue(rgbColor);

    final alpha = rgbColor.alpha / 255;

    return HspColor.extrapolate(
        <double>[hue, saturation, percievedBrightness, alpha]);
  }

  /// Converts a HSP color to a RGB color.
  static RgbColor hspToRgb(HspColor hspColor) {
    final hsp = hspColor.toFactoredList();

    var hue = hsp[0];
    final saturation = hsp[1];
    final perceivedBrightness = hsp[2];

    final hueIndex = (hue * 6).floor() % 6;
    final hueSegment = (hueIndex.isEven) ? hueIndex : hueIndex + 1;
    final hueSegmentSign = (hueIndex.isEven) ? 1 : -1;
    hue =
        6 * ((hueSegmentSign * hue) + (-1 * hueSegmentSign * (hueSegment / 6)));

    late double red, green, blue;

    if (saturation < 1) {
      final invertSaturation = 1 - saturation;
      final part = 1 + (hue * ((1 / invertSaturation) - 1));

      double calculateFirstValue(double a, double b, double c) =>
          perceivedBrightness /
          math.sqrt((a / invertSaturation / invertSaturation) +
              (b * part * part) +
              c);
      double calculateSecondValue(double firstValue) =>
          firstValue / invertSaturation;
      double calculateThirdValue(double firstValue, double secondValue) =>
          firstValue + (hue * (secondValue - firstValue));

      switch (hueIndex) {
        case 0:
          blue = calculateFirstValue(_pr, _pg, _pb).clamp(0.0, 1.0);
          red = calculateSecondValue(blue).clamp(0.0, 1.0);
          green = calculateThirdValue(blue, red).clamp(0.0, 1.0);
          break;
        case 1:
          blue = calculateFirstValue(_pg, _pr, _pb).clamp(0.0, 1.0);
          green = calculateSecondValue(blue).clamp(0.0, 1.0);
          red = calculateThirdValue(blue, green).clamp(0.0, 1.0);
          break;
        case 2:
          red = calculateFirstValue(_pg, _pb, _pr).clamp(0.0, 1.0);
          green = calculateSecondValue(red).clamp(0.0, 1.0);
          blue = calculateThirdValue(red, green).clamp(0.0, 1.0);
          break;
        case 3:
          red = calculateFirstValue(_pb, _pg, _pr).clamp(0.0, 1.0);
          blue = calculateSecondValue(red).clamp(0.0, 1.0);
          green = calculateThirdValue(red, blue).clamp(0.0, 1.0);
          break;
        case 4:
          green = calculateFirstValue(_pb, _pr, _pg).clamp(0.0, 1.0);
          blue = calculateSecondValue(green).clamp(0.0, 1.0);
          red = calculateThirdValue(green, blue).clamp(0.0, 1.0);
          break;
        case 5:
          green = calculateFirstValue(_pr, _pb, _pg).clamp(0.0, 1.0);
          red = calculateSecondValue(green).clamp(0.0, 1.0);
          blue = calculateThirdValue(green, red).clamp(0.0, 1.0);
          break;
      }
    } else {
      double calculateFirstValue(double a, double b) => math.sqrt(
          (perceivedBrightness * perceivedBrightness) / (a + (b * hue * hue)));
      double calculateSecondValue(double firstValue) => firstValue * hue;

      switch (hueIndex) {
        case 0:
          red = calculateFirstValue(_pr, _pg).clamp(0.0, 1.0);
          green = calculateSecondValue(red).clamp(0.0, 1.0);
          blue = 0;
          break;
        case 1:
          green = calculateFirstValue(_pg, _pr).clamp(0.0, 1.0);
          red = calculateSecondValue(green).clamp(0.0, 1.0);
          blue = 0;
          break;
        case 2:
          green = calculateFirstValue(_pg, _pb).clamp(0.0, 1.0);
          blue = calculateSecondValue(green).clamp(0.0, 1.0);
          red = 0;
          break;
        case 3:
          blue = calculateFirstValue(_pb, _pg).clamp(0.0, 1.0);
          green = calculateSecondValue(blue).clamp(0.0, 1.0);
          red = 0;
          break;
        case 4:
          blue = calculateFirstValue(_pb, _pr).clamp(0.0, 1.0);
          red = calculateSecondValue(blue).clamp(0.0, 1.0);
          green = 0;
          break;
        case 5:
          red = calculateFirstValue(_pr, _pb).clamp(0.0, 1.0);
          blue = calculateSecondValue(red).clamp(0.0, 1.0);
          green = 0;
          break;
      }
    }

    final alpha = hspColor.alpha / 255;

    return RgbColor.extrapolate(<double>[red, green, blue, alpha]);
  }

  /// Converts a color from any color space to HSL.
  static HsbColor toHsbColor(ColorModel color) => rgbToHsb(color.toRgbColor());

  /// Converts a RGB color to a HSB color.
  static HsbColor rgbToHsb(RgbColor rgbColor) {
    if (rgbColor.isBlack) HsbColor(0, 0, 0, rgbColor.alpha);
    if (rgbColor.isWhite) HsbColor(0, 0, 100, rgbColor.alpha);
    if (rgbColor.isMonochromatic) {
      return HsbColor(0, 0, rgbColor.red / 255 * 100, rgbColor.alpha);
    }

    final rgb = rgbColor.toFactoredList();
    final max = rgb.reduce(math.max);
    final min = rgb.reduce(math.min);
    final difference = max - min;
    final saturation = (max == 0.0) ? 0.0 : difference / max;
    final alpha = rgbColor.alpha / 255;

    return HsbColor.extrapolate(
        <double>[getHue(rgbColor), saturation, max, alpha]);
  }

  /// Converts a HSB color to a RGB color.
  static RgbColor hsbToRgb(HsbColor hsbColor) {
    final hsb = hsbColor.toFactoredList();

    final hue = hsb[0];
    final saturation = hsb[1];
    final value = hsb[2];

    late double red, green, blue;

    final hueIndex = (hue * 6).floor();

    final hueFloat = (hue * 6) - hueIndex;
    final hueSegment = (hueIndex.isEven) ? 1 - hueFloat : hueFloat;

    final a = value;
    final b = value * (1 - saturation);
    final c = value * (1 - (hueSegment * saturation));

    switch (hueIndex % 6) {
      case 0:
        red = a;
        green = c;
        blue = b;
        break;
      case 1:
        red = c;
        green = a;
        blue = b;
        break;
      case 2:
        red = b;
        green = a;
        blue = c;
        break;
      case 3:
        red = b;
        green = c;
        blue = a;
        break;
      case 4:
        red = c;
        green = b;
        blue = a;
        break;
      case 5:
        red = a;
        green = b;
        blue = c;
        break;
    }

    final alpha = hsbColor.alpha / 255;

    return RgbColor.extrapolate(<double>[red, green, blue, alpha]);
  }

  /// Converts a color from any color space to HSL.
  static LabColor toLabColor(ColorModel color) => rgbToLab(color.toRgbColor());

  /// Converts a RGB color to a LAB color using the
  /// XYZ color space as an intermediary.
  static LabColor rgbToLab(RgbColor rgbColor) {
    if (rgbColor.isBlack) return LabColor(0, 0, 0, rgbColor.alpha);
    if (rgbColor.isWhite) return LabColor(100, 0, 0, rgbColor.alpha);
    return xyzToLab(rgbColor.toXyzColor());
  }

  /// Converts an XYZ color to a LAB color.
  static LabColor xyzToLab(XyzColor xyzColor) {
    final xyz = xyzColor
        .toFactoredList()
        .map((xyzValue) => ((xyzValue > 0.008856)
                ? math.pow(xyzValue, 0.3334)
                : (7.787 * xyzValue) + (16 / 116))
            .toDouble())
        .toList();

    final x = xyz[0];
    final y = xyz[1];
    final z = xyz[2];

    final lightness = ((116 * y) - 16).clamp(0.0, 100.0);
    final a = ((x - y) * 500).clamp(-128.0, 127.0);
    final b = ((y - z) * 200).clamp(-128.0, 127.0);

    return LabColor(lightness, a, b, xyzColor.alpha);
  }

  /// Converts a LAB color to a RGB color using the
  /// XYZ color space as an intermediary.
  static RgbColor labToRgb(LabColor labColor) => xyzToRgb(labToXyz(labColor));

  /// Converts a XYZ color to a LAB color.
  static XyzColor labToXyz(LabColor labColor) {
    final lightness = labColor.lightness;
    final a = labColor.chromaticityA;
    final b = labColor.chromaticityB;

    var y = (lightness + 16) / 116;
    var x = (a / 500) + y;
    var z = y - (b / 200);

    final x3 = x * x * x;
    final z3 = z * z * z;

    x = (x3 > 0.008856) ? x3 : (116 * x - 16) / 903.3;
    y = (lightness > 0.008856 * 903.3)
        ? math.pow((lightness + 16) / 116, 3).toDouble()
        : lightness / 903.3;
    z = (z3 > 0.008856) ? z3 : (116 * z - 16) / 903.3;

    // LAB colors with their `a` values beneath and `b` values above the
    // RGB color space's bounds, such as LabColor(60, -128, 127), will
    // calculate their `x` and/or `z` values beneath 0, by at most -0.082.
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (z < 0) z = 0;

    final alpha = labColor.alpha / 255;

    return XyzColor.extrapolate(<double>[x, y, z, alpha]);
  }

  /// Converts a color from any color space to Oklab.
  static OklabColor toOklabColor(ColorModel color) =>
      rgbToOklab(color.toRgbColor());

  /// Converts an sRGB color to an Oklab color.
  static OklabColor rgbToOklab(RgbColor rgbColor) {
    if (rgbColor.isBlack) return OklabColor(0.0, 0.0, 0.0, rgbColor.alpha);
    if (rgbColor.isWhite) return OklabColor(1.0, 0.0, 0.0, rgbColor.alpha);

    final lrgb = rgbColor.linearize();

    final l = ((0.4122214708 * lrgb.red) +
            (0.5363325363 * lrgb.green) +
            (0.0514459929 * lrgb.blue))
        .cbrt();
    final m = ((0.2119034982 * lrgb.red) +
            (0.6806995451 * lrgb.green) +
            (0.1073969566 * lrgb.blue))
        .cbrt();
    final s = ((0.0883024619 * lrgb.red) +
            (0.2817188376 * lrgb.green) +
            (0.6299787005 * lrgb.blue))
        .cbrt();

    return OklabColor(
      (0.2104542553 * l) + (0.7936177850 * m) - (0.0040720468 * s),
      (1.9779984951 * l) - (2.4285922050 * m) + (0.4505937099 * s),
      (0.0259040371 * l) + (0.7827717662 * m) - (0.8086757660 * s),
      rgbColor.alpha,
    );
  }

  /// Converts an Oklab color to an RGB color.
  static RgbColor oklabToRgb(OklabColor oklabColor) {
    if (oklabColor.isBlack) {
      return RgbColor(0, 0, 0, oklabColor.alpha);
    }
    if (oklabColor.isWhite) {
      return RgbColor(255, 255, 255, oklabColor.alpha);
    }

    final l = (oklabColor.lightness +
            (0.3963377774 * oklabColor.chromaticityA) +
            (0.2158037573 * oklabColor.chromaticityB))
        .cubed();
    final m = (oklabColor.lightness -
            (0.1055613458 * oklabColor.chromaticityA) -
            (0.0638541728 * oklabColor.chromaticityB))
        .cubed();
    final s = (oklabColor.lightness -
            (0.0894841775 * oklabColor.chromaticityA) -
            (1.2914855480 * oklabColor.chromaticityB))
        .cubed();

    return _LinearRgbColor(
      (4.0767416621 * l) - (3.3077115913 * m) + (0.2309699292 * s),
      (-1.2684380046 * l) + (2.6097574011 * m) - (0.3413193965 * s),
      (-0.0041960863 * l) - (0.7034186147 * m) + (1.7076147010 * s),
    ).normalize().copyWith(alpha: oklabColor.alpha);
  }

  /// Converts a color from any color space to XYZ.
  static XyzColor toXyzColor(ColorModel color) => rgbToXyz(color.toRgbColor());

  /// Converts an RGB color to a XYZ color.
  static XyzColor rgbToXyz(RgbColor rgbColor) {
    if (rgbColor.isBlack) return XyzColor(0, 0, 0, rgbColor.alpha);
    if (rgbColor.isWhite) return XyzColor(100, 100, 100, rgbColor.alpha);

    final rgb = rgbColor
        .toFactoredList()
        .map((rgbValue) => ((rgbValue <= 0.04045)
                ? rgbValue / 12.92
                : math.pow((rgbValue + 0.055) / 1.055, 2.4))
            .toDouble())
        .toList();

    final red = rgb[0];
    final green = rgb[1];
    final blue = rgb[2];

    final x = _WhitePoints.rgb.x *
        ((red * 0.41239079926595) +
            (green * 0.35758433938387) +
            (blue * 0.18048078840183));
    final y = _WhitePoints.rgb.y *
        ((red * 0.21263900587151) +
            (green * 0.71516867876775) +
            (blue * 0.072192315360733));
    final z = _WhitePoints.rgb.z *
        ((red * 0.019330818715591) +
            (green * 0.11919477979462) +
            (blue * 0.95053215224966));

    return XyzColor(x, y, z, rgbColor.alpha);
  }

  /// Converts an XYZ color to a RGB color.
  static RgbColor xyzToRgb(XyzColor xyzColor) {
    final x = xyzColor.x / _WhitePoints.rgb.x;
    final y = xyzColor.y / _WhitePoints.rgb.y;
    final z = xyzColor.z / _WhitePoints.rgb.z;

    double red, green, blue;

    double factorValue(double value) {
      value = (value <= 0.0031308)
          ? value * 12.92
          : ((1.055 * math.pow(value, 1.0 / 2.4)) - 0.055);

      return [
        [0, value].reduce(math.max),
        1
      ].reduce(math.min).toDouble();
    }

    red = factorValue((x * 3.240969941904521) +
        (y * -1.537383177570093) +
        (z * -0.498610760293));
    green = factorValue((x * -0.96924363628087) +
        (y * 1.87596750150772) +
        (z * 0.041555057407175));
    blue = factorValue((x * 0.055630079696993) +
        (y * -0.20397695888897) +
        (z * 1.056971514242878));

    final alpha = xyzColor.alpha / 255;

    return RgbColor.extrapolate(<double>[red, green, blue, alpha]);
  }

  /// Calculates the [rgbColor]s hue on a 0 to 1 scale,
  /// as used by the HSL, HSP, and HSB color models.
  static double getHue(RgbColor rgbColor) {
    double hue;

    final rgb = rgbColor.toFactoredList();

    final red = rgb[0];
    final green = rgb[1];
    final blue = rgb[2];

    final max = rgb.reduce(math.max);
    final min = rgb.reduce(math.min);
    final difference = max - min;

    if (max == min) {
      hue = 0;
    } else {
      if (max == red) {
        hue = (green - blue) / difference + ((green < blue) ? 6 : 0);
      } else if (max == green) {
        hue = (blue - red) / difference + 2;
      } else {
        hue = (red - green) / difference + 4;
      }

      hue /= 6;
    }

    return hue;
  }

  /// The coefficient used for gamma-correcting a color's red value
  /// based on its contribution to lightness.
  ///
  /// See: https://en.wikipedia.org/wiki/HSL_and_HSV#Lightness
  ///
  /// Used to calculate the HSP color space's [percievedBrightness] value.
  static const double _pr = 0.2989;

  /// The coefficient used for gamma-correcting a color's green value
  /// based on its contribution to lightness.
  ///
  /// See: https://en.wikipedia.org/wiki/HSL_and_HSV#Lightness
  ///
  /// Used to calculate the HSP color space's [percievedBrightness] value.
  static const double _pg = 0.587;

  /// The coefficient used for gamma-correcting a color's blue value
  /// based on its contribution to lightness.
  ///
  /// See: https://en.wikipedia.org/wiki/HSL_and_HSV#Lightness
  ///
  /// Used to calculate the HSP color space's [percievedBrightness] value.
  static const double _pb = 0.114;
}

class _WhitePoints {
  const _WhitePoints({
    required this.x,
    required this.y,
    required this.z,
  });

  final num x, y, z;

  /// The whitepoints used when converting RGB colors to/from
  /// the LAB color space.
  ///
  /// These white points were calculated for this package, as such they
  /// are not derived from one of the CIE standard illuminants.
  static const _WhitePoints rgb = _WhitePoints(
    x: 105.21266389510953,
    y: 100.0000000000007,
    z: 91.82249511582535,
  );
}

extension _LinearizeRgbColor on RgbColor {
  /// Converts this [RgbColor] to a linear RGB color.
  _LinearRgbColor linearize() => _LinearRgbColor.fromList(
        toFactoredList()
            .map<double>((value) => value >= 0.0031308
                ? (1.055 * math.pow(value, 1.0 / 2.4)) - 0.055
                : 12.92 * value)
            .toList(),
      );
}

/// A linearized RGB color.
class _LinearRgbColor {
  const _LinearRgbColor(
    this.red,
    this.green,
    this.blue,
  );

  /// Constructs a linear RGB color from a list of [values].
  factory _LinearRgbColor.fromList(List<double> values) {
    assert(values.length == 3);
    return _LinearRgbColor(values[0], values[1], values[2]);
  }

  final double red, green, blue;

  /// Returns this linear RGB color as a list of values.
  List<double> toList() => <double>[red, green, blue];

  /// Converts this linear RGB color back to a [RgbColor].
  RgbColor normalize() => RgbColor.fromList(
        toList()
            .map<double>((value) => ((value >= 0.04045
                        ? math.pow((value + 0.055) / 1.055, 2.4).toDouble()
                        : value / 12.92) *
                    255)
                .clamp(0, 255))
            .toList(),
      );
}
