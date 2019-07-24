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

class ColorConverter {
  /// Converts a color from any color space to RGB.
  static RgbColor toRgbColor(ColorModel color) {
    assert(color != null);

    if (color.isBlack) return RgbColor(0, 0, 0);
    if (color.isWhite) return RgbColor(255, 255, 255);

    RgbColor rgbColor;

    switch (color.runtimeType) {
      case CmykColor: rgbColor = _cmykToRgb(color); break;
      case HsiColor: rgbColor = _hsiToRgb(color); break;
      case HslColor: rgbColor = _hslToRgb(color); break;
      case HspColor: rgbColor = _hspToRgb(color); break;
      case HsvColor: rgbColor = _hsvToRgb(color); break;
      case LabColor: rgbColor = _labToRgb(color); break;
      case RgbColor: rgbColor = color; break;
      case XyzColor: rgbColor = _xyzToRgb(color); break;
    }

    return rgbColor;
  }

  /// Converts a color from any color space to CMYK.
  static CmykColor toCmykColor(ColorModel color) {
    assert(color != null);

    return _rgbToCmyk(color.toRgbColor());
  }

  /// Converts a RGB color to a CMYK color.
  static CmykColor _rgbToCmyk(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return CmykColor(0, 0, 0, 100);
    if (rgbColor.isWhite) return CmykColor(0, 0, 0, 0);

    final List<double> rgb = rgbColor.toFactoredList();

    List<double> cmy = rgb.map((double rgbValue) => 1 - rgbValue).toList();

    final double k = cmy.reduce(math.min);

    final List<double> cmyk = cmy.map((double cmyValue) =>
      (cmyValue - k) / (1 - k),
    ).toList()..add(k);

    return CmykColor.extrapolate(cmyk);
  }

  /// Converts a CMYK color to a RGB color.
  static RgbColor _cmykToRgb(CmykColor cmykColor) {
    assert(cmykColor != null);

    final List<double> cmy = cmykColor.toFactoredList();

    final double k = cmy.removeLast();

    final List<double> rgb = cmy.map((double cmyValue) =>
      1 - ((cmyValue * (1 - k)) + k).clamp(0, 1).toDouble(),
    ).toList();

    return RgbColor.extrapolate(rgb);
  }

  /// Converts a color from any color space to HSI.
  static HsiColor toHsiColor(ColorModel color) {
    assert(color != null);

    return _rgbToHsi(color.toRgbColor());
  }

  /// Converts a RGB color to a HSI color.
  static HsiColor _rgbToHsi(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return HsiColor(0, 0, 0);
    if (rgbColor.isWhite) return HsiColor(0, 0, 100);

    final List<num> rgb = rgbColor.toPreciseList();

    final num sum = rgb.reduce((a, b) => a + b);

    final double red = rgb[0] / sum;
    final double green = rgb[1] / sum;
    final double blue = rgb[2] / sum;

    double hue = math.acos(
      (0.5 * ((red - green) + (red - blue))) /
        math.sqrt(((red - green) * (red - green)) +
          ((red - blue) * (green - blue))));

    if (blue > green) hue = (2 * math.pi) - hue;

    if (hue.isNaN) { // Achromatic
      hue = 0;
    } else {
      hue /= math.pi * 2;
    }

    final double min = <double>[red, green, blue].reduce(math.min);

    final double saturation = 1 - 3 * min;

    final double intensity = sum / 3 / 255;

    return HsiColor.extrapolate(<double>[hue, saturation, intensity]);
  }

  /// Converts a HSI color to a RGB color.
  static RgbColor _hsiToRgb(HsiColor hsiColor) {
    assert(hsiColor != null);

    final List<double> hsi = hsiColor.toFactoredList();

    double hue = hsi[0] * math.pi * 2;
    final double saturation = hsi[1];
    final double intensity = hsi[2];

    final double pi3 = math.pi / 3;

    double red, green, blue;

    final double firstValue = intensity * (1 - saturation);

    double calculateSecondValue(double hue) => intensity * (1 +
      (saturation * math.cos(hue) / math.cos(pi3 - hue)));

    double calculateThirdValue(double hue) => intensity * (1 +
      (saturation * (1 - (math.cos(hue) / math.cos(pi3 - hue)))));

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

    return _rgbToHsl(color.toRgbColor());
  }

  /// Converts a RGB color to a HSL color.
  static HslColor _rgbToHsl(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return HslColor(0, 0, 0);
    if (rgbColor.isWhite) return HslColor(0, 0, 100);

    final List<double> rgb = rgbColor.toFactoredList();

    final double max = rgb.reduce(math.max);
    final double min = rgb.reduce(math.min);
    final double difference = max - min;

    final double lightness = (max + min) / 2;

    final double saturation = (lightness > 0.5) ?
      difference / (2 - max - min) :
      difference / (max + min);

    return HslColor.extrapolate(<double>[_getHue(rgbColor), saturation, lightness]);
  }

  /// Converts a HSL color to a RGB color.
  static RgbColor _hslToRgb(HslColor hslColor) {
    assert(hslColor != null);

    final List<double> hsl = hslColor.toFactoredList();

    final double hue = hsl[0];
    final double saturation = hsl[1];
    final double lightness = hsl[2];

    double red, green, blue;

    if (saturation == 0) {
      red = green = blue = lightness;
    } else {
      final double q = (lightness < 0.5) ? lightness * (1 + saturation) :
        lightness + saturation - (lightness * saturation);

      final double p = (2 * lightness) - q;

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

    return _rgbToHsp(color.toRgbColor());
  }

  /// Converts a RGB color to a HSP color.
  static HspColor _rgbToHsp(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return HspColor(0, 0, 0);
    if (rgbColor.isWhite) return HspColor(0, 0, 100);

    final List<double> rgb = rgbColor.toFactoredList();

    final double red = rgb[0];
    final double green = rgb[1];
    final double blue = rgb[2];

    final double percievedBrightness = math.sqrt((red * red * _pr) +
      (green * green * _pg) + (blue * blue * _pb));

    final double max = rgb.reduce(math.max);
    final double min = rgb.reduce(math.min);

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
  static RgbColor _hspToRgb(HspColor hspColor) {
    assert(hspColor != null);

    final List<double> hsp = hspColor.toFactoredList();

    double hue = hsp[0];
    final double saturation = hsp[1];
    final double perceivedBrightness = hsp[2];

    final int hueIndex = (hue * 6).floor() % 6;

    final int hueSegment = (hueIndex.isEven) ? hueIndex : hueIndex + 1;
    final int hueSegmentSign = (hueIndex.isEven) ? 1 : -1;
    hue = 6 * ((hueSegmentSign * hue) +
      (-1 * hueSegmentSign * (hueSegment / 6)));

    double red, green, blue;

    if (saturation < 1) {
      final double invertSaturation = 1 - saturation;
      final double part = 1 + (hue * ((1 / invertSaturation) - 1));

      double calculateFirstValue(double a, double b, double c) =>
        perceivedBrightness / math.sqrt((a / invertSaturation
          / invertSaturation) + (b * part * part) + c);

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

    return _rgbToHsv(color.toRgbColor());
  }

  /// Converts a RGB color to a HSV color.
  static HsvColor _rgbToHsv(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) HsvColor(0, 0, 0);
    if (rgbColor.isWhite) HsvColor(0, 0, 100);

    final List<double> rgb = rgbColor.toFactoredList();

    final double max = rgb.reduce(math.max);
    final double min = rgb.reduce(math.min);
    final double difference = max - min;

    final double saturation = (max == 0) ? 0 : difference / max;

    return HsvColor.extrapolate(<double>[_getHue(rgbColor), saturation, max]);
  }

  /// Converts a HSV color to a RGB color.
  static RgbColor _hsvToRgb(HsvColor hsvColor) {
    assert(hsvColor != null);

    final List<double> hsv = hsvColor.toFactoredList();

    final double hue = hsv[0];
    final double saturation = hsv[1];
    final double value = hsv[2];

    double red, green, blue;

    final int hueIndex = (hue * 6).floor();

    final double hueFloat = (hue * 6) - hueIndex;
    final double hueSegment = (hueIndex.isEven) ? 1 - hueFloat : hueFloat;

    final double a = value;
    final double b = value * (1 - saturation);
    final double c = value * (1 - (hueSegment * saturation));

    switch (hueIndex % 6) {
      case 0: red = a; green = c; blue = b; break;
      case 1: red = c; green = a; blue = b; break;
      case 2: red = b; green = a; blue = c; break;
      case 3: red = b; green = c; blue = a; break;
      case 4: red = c; green = b; blue = a; break;
      case 5: red = a; green = b; blue = c; break;
    }

    return RgbColor.extrapolate(<double>[red, green, blue]);
  }

  /// Converts a color from any color space to HSL.
  static LabColor toLabColor(ColorModel color) {
    assert(color != null);

    return _rgbToLab(color.toRgbColor());
  }

  /// Converts a RGB color to a LAB color using the
  /// XYZ color space as an intermediary.
  static LabColor _rgbToLab(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return LabColor(0, 0, 0);
    if (rgbColor.isWhite) return LabColor(100, 0, 0);

    return _xyzToLab(rgbColor.toXyzColor());
  }

  /// Converts an XYZ color to a LAB color.
  static LabColor _xyzToLab(XyzColor xyzColor) {
    assert(xyzColor != null);

    final List<double> xyz = xyzColor.toFactoredList()
      .map((double xyzValue) => ((xyzValue > 0.008856) ?
        math.pow(xyzValue, 0.3334) : (7.787 * xyzValue) + (16 / 116)
      ).toDouble()).toList();

    final double x = xyz[0];
    final double y = xyz[1];
    final double z = xyz[2];

    final double lightness = (116 * y) - 16;
    final double a = (x - y) * 500;
    final double b = (y - z) * 200;

    return LabColor(lightness, a, b);
  }

  /// Converts a LAB color to a RGB color using the
  /// XYZ color space as an intermediary.
  static RgbColor _labToRgb(LabColor labColor) {
    assert(labColor != null);

    return _xyzToRgb(_labToXyz(labColor));
  }

  /// Converts a XYZ color to a LAB color.
  static XyzColor _labToXyz(LabColor labColor) {
    assert(labColor != null);

    final num lightness = labColor.lightness;
    final num a = labColor.a;
    final num b = labColor.b;

    double y = (lightness + 16) / 116;
    double x = (a / 500) + y;
    double z = y - (b / 200);

    final double x3 = x * x * x;
    final double z3 = z * z * z;

    x = (x3 > 0.008856) ? x3 : (116 * x - 16) / 903.3;

    y = (lightness > 0.008856 * 903.3) ?
      math.pow((lightness + 16) / 116, 3) :
      lightness / 903.3;

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

    return _rgbToXyz(color.toRgbColor());
  }

  /// Converts an RGB color to a XYZ color.
  static XyzColor _rgbToXyz(RgbColor rgbColor) {
    assert(rgbColor != null);

    if (rgbColor.isBlack) return XyzColor(0, 0, 0);
    if (rgbColor.isWhite) return XyzColor(100, 100, 100);

    final List<double> rgb = rgbColor.toFactoredList()
      .map((double rgbValue) => ((rgbValue <= 0.04045) ?
        rgbValue / 12.92 : math.pow((rgbValue + 0.055) / 1.055, 2.4)
      ).toDouble()).toList();

    final double red = rgb[0];
    final double green = rgb[1];
    final double blue = rgb[2];

    final double x = XyzColor.whitePoint.x * ((red * 0.41239079926595) +
      (green * 0.35758433938387) + (blue * 0.18048078840183));
    final double y = XyzColor.whitePoint.y * ((red * 0.21263900587151) +
      (green * 0.71516867876775) + (blue * 0.072192315360733));
    final double z = XyzColor.whitePoint.z * ((red * 0.019330818715591) +
      (green * 0.11919477979462) + (blue * 0.95053215224966));

    return XyzColor(x, y, z);
  }

  /// Converts an XYZ color to a RGB color.
  static RgbColor _xyzToRgb(XyzColor xyzColor) {
    assert(xyzColor != null);

    final double x = xyzColor.x / XyzColor.whitePoint.x;
    final double y = xyzColor.y / XyzColor.whitePoint.y;
    final double z = xyzColor.z / XyzColor.whitePoint.z;

    double red, green, blue;

    double factorValue(double value) {
      value = (value <= 0.0031308) ? value * 12.92 :
        ((1.055 * math.pow(value, 1.0 / 2.4)) - 0.055);

      return [[0, value].reduce(math.max), 1].reduce(math.min).toDouble();
    }

    red = factorValue((x * 3.240969941904521) +
      (y * -1.537383177570093) + (z * -0.498610760293));
    green = factorValue((x * -0.96924363628087) +
      (y * 1.87596750150772) + (z * 0.041555057407175));
    blue = factorValue((x * 0.055630079696993) +
      (y * -0.20397695888897) + (z * 1.056971514242878));

    return RgbColor.extrapolate(<double>[red, green, blue]);
  }

  /// Calculates the [rgbColor]s hue on a 0 to 1 scale,
  /// as used by the HSL, HSP, and HSV color models.
  static double _getHue(RgbColor rgbColor) {
    assert(rgbColor != null);

    double hue;

    final List<double> rgb = rgbColor.toFactoredList();

    final double red = rgb[0];
    final double green = rgb[1];
    final double blue = rgb[2];

    final double max = rgb.reduce(math.max);
    final double min = rgb.reduce(math.min);
    final double difference = max - min;

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
