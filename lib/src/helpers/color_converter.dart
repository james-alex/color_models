/// The CMYK to/from RGB conversion algorithms were adapted from:
/// https://gist.github.com/felipesabino/5066336
///
/// The HSI, XYZ, and XYZ to LAB conversion algorithms were adapted from:
/// https://github.com/colorjs/color-space/
///
/// The LAB to XYZ conversion algorithm was adapted from:
/// https://stackoverflow.com/questions/46627367/convert-lab-to-xyz
///
/// The HSL and HSV conversion algorithms were adapted from:
/// http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
///
/// The HSP conversion algorithms were adapted from:
/// http://alienryderflex.com/hsp.html

import 'dart:math' as math;
import '../color_model.dart';

/// A utility class with color conversion methods to and
/// from RGB for each color model included in this package.
class ColorConverter {
  ColorConverter._();

  /// Returns a [hex] color as a RGB color.
  static RgbColor hexToRgb(String hex) {
    assert(hex != null);

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
  static CmykColor toCmykColor(ColorModel color) {
    assert(color != null);

    return rgbToCmyk(color.toRgbColor());
  }

  /// Converts a RGB color to a CMYK color.
  static CmykColor rgbToCmyk(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return CmykColor(0, 0, 0, 100);
    if (rgbColor.isWhite) return CmykColor(0, 0, 0, 0);

    final rgb = rgbColor.toFactoredList();

    final cmy = rgb.map((rgbValue) => 1 - rgbValue).toList();

    final k = cmy.reduce(math.min);

    final cmyk = cmy.map((cmyValue) => (cmyValue - k) / (1 - k)).toList()
      ..add(k);

    return CmykColor.extrapolate(cmyk);
  }

  /// Converts a CMYK color to a RGB color.
  static RgbColor cmykToRgb(CmykColor cmykColor) {
    assert(cmykColor != null);

    final cmy = cmykColor.toFactoredList();

    final k = cmy.removeLast();

    final rgb = cmy
        .map(
            (cmyValue) => 1 - ((cmyValue * (1 - k)) + k).clamp(0, 1).toDouble())
        .toList();

    return RgbColor.extrapolate(rgb);
  }

  /// Converts a color from any color space to HSI.
  static HsiColor toHsiColor(ColorModel color) {
    assert(color != null);

    return rgbToHsi(color.toRgbColor());
  }

  /// Converts a RGB color to a HSI color.
  static HsiColor rgbToHsi(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return HsiColor(0, 0, 0);
    if (rgbColor.isWhite) return HsiColor(0, 0, 100);

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

    return HsiColor.extrapolate(<double>[hue, saturation, intensity]);
  }

  /// Converts a HSI color to a RGB color.
  static RgbColor hsiToRgb(HsiColor hsiColor) {
    assert(hsiColor != null);

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

    return RgbColor.extrapolate(<double>[red, green, blue]);
  }

  /// Converts a color from any color space to HSL.
  static HslColor toHslColor(ColorModel color) {
    assert(color != null);

    return rgbToHsl(color.toRgbColor());
  }

  /// Converts a RGB color to a HSL color.
  static HslColor rgbToHsl(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return HslColor(0, 0, 0);
    if (rgbColor.isWhite) return HslColor(0, 0, 100);

    final rgb = rgbColor.toFactoredList();

    final max = rgb.reduce(math.max);
    final min = rgb.reduce(math.min);
    final difference = max - min;

    final lightness = (max + min) / 2;

    final saturation = (lightness > 0.5)
        ? difference / (2 - max - min)
        : difference / (max + min);

    return HslColor.extrapolate(
        <double>[_getHue(rgbColor), saturation, lightness]);
  }

  /// Converts a HSL color to a RGB color.
  static RgbColor hslToRgb(HslColor hslColor) {
    assert(hslColor != null);

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

    return RgbColor.extrapolate(<double>[red, green, blue]);
  }

  /// Converts a color from any color space to HSL.
  static HspColor toHspColor(ColorModel color) {
    assert(color != null);

    return rgbToHsp(color.toRgbColor());
  }

  /// Converts a RGB color to a HSP color.
  static HspColor rgbToHsp(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return HspColor(0, 0, 0);
    if (rgbColor.isWhite) return HspColor(0, 0, 100);

    final rgb = rgbColor.toFactoredList();

    final red = rgb[0];
    final green = rgb[1];
    final blue = rgb[2];

    final percievedBrightness = math
        .sqrt((red * red * _pr) + (green * green * _pg) + (blue * blue * _pb));

    final max = rgb.reduce(math.max);
    final min = rgb.reduce(math.min);

    double hue;
    double saturation;

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

    hue ??= _getHue(rgbColor);

    return HspColor.extrapolate(<double>[hue, saturation, percievedBrightness]);
  }

  /// Converts a HSP color to a RGB color.
  static RgbColor hspToRgb(HspColor hspColor) {
    assert(hspColor != null);

    final hsp = hspColor.toFactoredList();

    var hue = hsp[0];
    final saturation = hsp[1];
    final perceivedBrightness = hsp[2];

    final hueIndex = (hue * 6).floor() % 6;

    final hueSegment = (hueIndex.isEven) ? hueIndex : hueIndex + 1;
    final hueSegmentSign = (hueIndex.isEven) ? 1 : -1;
    hue =
        6 * ((hueSegmentSign * hue) + (-1 * hueSegmentSign * (hueSegment / 6)));

    double red, green, blue;

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
          blue = calculateFirstValue(_pr, _pg, _pb);
          red = calculateSecondValue(blue);
          green = calculateThirdValue(blue, red);
          break;
        case 1:
          blue = calculateFirstValue(_pg, _pr, _pb);
          green = calculateSecondValue(blue);
          red = calculateThirdValue(blue, green);
          break;
        case 2:
          red = calculateFirstValue(_pg, _pb, _pr);
          green = calculateSecondValue(red);
          blue = calculateThirdValue(red, green);
          break;
        case 3:
          red = calculateFirstValue(_pb, _pg, _pr);
          blue = calculateSecondValue(red);
          green = calculateThirdValue(red, blue);
          break;
        case 4:
          green = calculateFirstValue(_pb, _pr, _pg);
          blue = calculateSecondValue(green);
          red = calculateThirdValue(green, blue);
          break;
        case 5:
          green = calculateFirstValue(_pr, _pb, _pg);
          red = calculateSecondValue(green);
          blue = calculateThirdValue(green, red);
          break;
      }
    } else {
      double calculateFirstValue(double a, double b) => math.sqrt(
          (perceivedBrightness * perceivedBrightness) / (a + (b * hue * hue)));

      double calculateSecondValue(double firstValue) => firstValue * hue;

      switch (hueIndex) {
        case 0:
          red = calculateFirstValue(_pr, _pg);
          green = calculateSecondValue(red);
          blue = 0;
          break;
        case 1:
          green = calculateFirstValue(_pg, _pr);
          red = calculateSecondValue(green);
          blue = 0;
          break;
        case 2:
          green = calculateFirstValue(_pg, _pb);
          blue = calculateSecondValue(green);
          red = 0;
          break;
        case 3:
          blue = calculateFirstValue(_pb, _pg);
          green = calculateSecondValue(blue);
          red = 0;
          break;
        case 4:
          blue = calculateFirstValue(_pb, _pr);
          red = calculateSecondValue(blue);
          green = 0;
          break;
        case 5:
          red = calculateFirstValue(_pr, _pb);
          blue = calculateSecondValue(red);
          green = 0;
          break;
      }
    }

    if (red > 1) red = 1;
    if (green > 1) green = 1;
    if (blue > 1) blue = 1;

    return RgbColor.extrapolate(<double>[red, green, blue]);
  }

  /// Converts a color from any color space to HSL.
  static HsvColor toHsvColor(ColorModel color) {
    assert(color != null);

    return rgbToHsv(color.toRgbColor());
  }

  /// Converts a RGB color to a HSV color.
  static HsvColor rgbToHsv(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) HsvColor(0, 0, 0);
    if (rgbColor.isWhite) HsvColor(0, 0, 100);

    final rgb = rgbColor.toFactoredList();

    final max = rgb.reduce(math.max);
    final min = rgb.reduce(math.min);
    final difference = max - min;

    final saturation = (max == 0.0) ? 0.0 : difference / max;

    return HsvColor.extrapolate(<double>[_getHue(rgbColor), saturation, max]);
  }

  /// Converts a HSV color to a RGB color.
  static RgbColor hsvToRgb(HsvColor hsvColor) {
    assert(hsvColor != null);

    final hsv = hsvColor.toFactoredList();

    final hue = hsv[0];
    final saturation = hsv[1];
    final value = hsv[2];

    double red, green, blue;

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

    return RgbColor.extrapolate(<double>[red, green, blue]);
  }

  /// Converts a color from any color space to HSL.
  static LabColor toLabColor(ColorModel color) {
    assert(color != null);

    return rgbToLab(color.toRgbColor());
  }

  /// Converts a RGB color to a LAB color using the
  /// XYZ color space as an intermediary.
  static LabColor rgbToLab(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return LabColor(0, 0, 0);
    if (rgbColor.isWhite) return LabColor(100, 0, 0);

    return xyzToLab(rgbColor.toXyzColor());
  }

  /// Converts an XYZ color to a LAB color.
  static LabColor xyzToLab(XyzColor xyzColor) {
    assert(xyzColor != null);

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

    final lightness = (116 * y) - 16;
    final a = (x - y) * 500;
    final b = (y - z) * 200;

    return LabColor(lightness, a, b);
  }

  /// Converts a LAB color to a RGB color using the
  /// XYZ color space as an intermediary.
  static RgbColor labToRgb(LabColor labColor) {
    assert(labColor != null);

    return xyzToRgb(labToXyz(labColor));
  }

  /// Converts a XYZ color to a LAB color.
  static XyzColor labToXyz(LabColor labColor) {
    assert(labColor != null);

    final lightness = labColor.lightness;
    final a = labColor.a;
    final b = labColor.b;

    var y = (lightness + 16) / 116;
    var x = (a / 500) + y;
    var z = y - (b / 200);

    final x3 = x * x * x;
    final z3 = z * z * z;

    x = (x3 > 0.008856) ? x3 : (116 * x - 16) / 903.3;

    y = (lightness > 0.008856 * 903.3)
        ? math.pow((lightness + 16) / 116, 3)
        : lightness / 903.3;

    z = (z3 > 0.008856) ? z3 : (116 * z - 16) / 903.3;

    // LAB colors with their `a` values beneath and `b` values above the
    // RGB color space's bounds, such as LabColor(60, -128, 127), will
    // calculate their `x` and/or `z` values beneath 0, by at most -0.082.
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (z < 0) z = 0;

    return XyzColor.extrapolate(<double>[x, y, z]);
  }

  /// Converts a color from any color space to XYZ.
  static XyzColor toXyzColor(ColorModel color) {
    assert(color != null);

    return rgbToXyz(color.toRgbColor());
  }

  /// Converts an RGB color to a XYZ color.
  static XyzColor rgbToXyz(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return XyzColor(0, 0, 0);
    if (rgbColor.isWhite) return XyzColor(100, 100, 100);

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

    final x = XyzColor.whitePoint.x *
        ((red * 0.41239079926595) +
            (green * 0.35758433938387) +
            (blue * 0.18048078840183));
    final y = XyzColor.whitePoint.y *
        ((red * 0.21263900587151) +
            (green * 0.71516867876775) +
            (blue * 0.072192315360733));
    final z = XyzColor.whitePoint.z *
        ((red * 0.019330818715591) +
            (green * 0.11919477979462) +
            (blue * 0.95053215224966));

    return XyzColor(x, y, z);
  }

  /// Converts an XYZ color to a RGB color.
  static RgbColor xyzToRgb(XyzColor xyzColor) {
    assert(xyzColor != null);

    final x = xyzColor.x / XyzColor.whitePoint.x;
    final y = xyzColor.y / XyzColor.whitePoint.y;
    final z = xyzColor.z / XyzColor.whitePoint.z;

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

    return RgbColor.extrapolate(<double>[red, green, blue]);
  }

  /// Calculates the [rgbColor]s hue on a 0 to 1 scale,
  /// as used by the HSL, HSP, and HSV color models.
  static double _getHue(RgbColor rgbColor) {
    assert(rgbColor != null);

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
