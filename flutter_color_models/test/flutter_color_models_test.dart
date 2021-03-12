import 'package:flutter/painting.dart' show Color;
import 'package:test/test.dart';
import 'package:flutter_color_models/flutter_color_models.dart';

/// A set of colors containing black, white, grey, 6 other
/// colors, each within a different part of the hue spectrum,
/// as well as pure red, green, blue, yellow, cyan, and pink.
const List<Color> _testColors = <Color>[
  Color(0xFF000000), // Black
  Color(0xFF909090), // Grey
  Color(0xFFFFFFFF), // White
  Color(0xFFF06F0C), // Hue 26°
  Color(0xFF66CC33), // Hue 101°
  Color(0xFF33CC99), // Hue 161°
  Color(0xFF0C6699), // Hue 201°
  Color(0xFF782AD4), // Hue 267°
  Color(0xFFD1106E), // Hue 331°
  Color(0xFFFF0000), // red
  Color(0xFF00FF00), // green
  Color(0xFF0000FF), // blue
  Color(0xFFFFFF00), // yellow
  Color(0xFF00FFFF), // cyan
  Color(0xFFFF00FF), // pink
];

/// Each of the color models' types.
enum _ColorModels { cmyk, hsi, hsl, hsp, hsb, lab, rgb, xyz }

/// The following tests convert each of the test [Color]s from
/// RGB to each of the other color spaces. They are then converted
/// back to the RGB color space and are expected to equal the
/// original RGB color value, before finally being recast
/// as a [Color] and compared to the original [Color].
void main() {
  group('Color Conversions', () {
    test('CMYK Conversions', () {
      for (var color in _testColors) {
        final rgbColor = RgbColor.fromColor(color);
        final cmykColor = rgbColor.toCmykColor();
        expect(rgbColor.equals(cmykColor), equals(true));
        expect(cmykColor.toColor(), equals(color));
      }
    });

    test('HSI Conversions', () {
      for (var color in _testColors) {
        final rgbColor = RgbColor.fromColor(color);
        final hsiColor = rgbColor.toHsiColor();
        expect(rgbColor.equals(hsiColor), equals(true));
        expect(hsiColor.toColor(), equals(color));
      }
    });

    test('HSL Conversions', () {
      for (var color in _testColors) {
        final rgbColor = RgbColor.fromColor(color);
        final hslColor = rgbColor.toHslColor();
        expect(rgbColor.equals(hslColor), equals(true));
        expect(hslColor.toColor(), equals(color));
      }
    });

    test('HSP Conversions', () {
      for (var color in _testColors) {
        final rgbColor = RgbColor.fromColor(color);
        final hspColor = rgbColor.toHspColor();
        expect(rgbColor.equals(hspColor), equals(true));
        expect(hspColor.toColor(), equals(color));
      }
    });

    test('HSB Conversions', () {
      for (var color in _testColors) {
        final rgbColor = RgbColor.fromColor(color);
        final hsbColor = rgbColor.toHsbColor();
        expect(rgbColor.equals(hsbColor), equals(true));
        expect(hsbColor.toColor(), equals(color));
      }
    });

    test('LAB Conversions', () {
      for (var color in _testColors) {
        final rgbColor = RgbColor.fromColor(color);
        final labColor = rgbColor.toLabColor();
        expect(rgbColor.equals(labColor), equals(true));
        expect(labColor.toColor(), equals(color));
      }
    });

    test('XYZ Conversions', () {
      for (var color in _testColors) {
        final rgbColor = RgbColor.fromColor(color);
        final xyzColor = rgbColor.toXyzColor();
        expect(rgbColor.equals(xyzColor), equals(true));
        expect(xyzColor.toColor(), equals(color));
      }
    });

    test('Chained Conversions', () {
      for (var color in _testColors) {
        var copy = color;

        final cmykColor = CmykColor.fromColor(copy);
        copy = cmykColor.toColor();
        expect(copy, equals(color));

        final hsiColor = HsiColor.fromColor(copy);
        copy = hsiColor.toColor();
        expect(copy, equals(color));

        final hslColor = HslColor.fromColor(copy);
        copy = hslColor.toColor();
        expect(copy, equals(color));

        final hspColor = HspColor.fromColor(copy);
        copy = hspColor.toColor();
        expect(copy, equals(color));

        final hsbColor = HsbColor.fromColor(copy);
        copy = hsbColor.toColor();
        expect(copy, equals(color));

        final labColor = LabColor.fromColor(copy);
        copy = labColor.toColor();
        expect(copy, equals(color));

        final rgbColor = RgbColor.fromColor(copy);
        copy = rgbColor.toColor();
        expect(copy, equals(color));

        final xyzColor = XyzColor.fromColor(copy);
        copy = xyzColor.toColor();
        expect(copy, equals(color));
      }
    });
  });

  test('Interpolate', () {
    for (var i = 0; i < _testColors.length; i++) {
      for (var j = 0; j < _testColors.length; j++) {
        for (var colorModel1 in _ColorModels.values) {
          final color1 = _toColorModel(colorModel1, _testColors[i]);
          final values1 = color1 is RgbColor
              ? color1.toPreciseListWithAlpha()
              : color1.toListWithAlpha();

          for (var colorModel2 in _ColorModels.values) {
            final color2 = _toColorModel(colorModel2, _testColors[j]);
            final values2 = color1 is RgbColor
                ? color2.toRgbColor().toPreciseListWithAlpha()
                : _toColorModel(colorModel1, _testColors[j]).toListWithAlpha();

            for (var steps = 1; steps <= 100; steps++) {
              final colors = color1.lerpTo(color2, steps);

              for (var k = 0; k < colors.length; k++) {
                final step = (1 / (steps + 1)) * k;
                final color = colors[k];
                final values = color is RgbColor
                    ? color.toPreciseListWithAlpha()
                    : color.toListWithAlpha();

                for (var l = 0; l < values.length; l++) {
                  final expectedValue = k == colors.length - 1
                      ? _round(values2[l])
                      : _interpolateValue(values1[l], values2[l], step);

                  if (color2 is LabColor || color2 is HspColor) {
                    expect(
                        (values[l] - expectedValue).abs() < 0.25, equals(true));
                  } else {
                    expect((values[l] - expectedValue).abs() < 0.00001,
                        equals(true));
                  }
                }
              }
            }
          }
        }
      }
    }
  });
}

/// Converts [color] to the color space defined by [colorModel].
ColorModel _toColorModel(_ColorModels colorModel, Color color) {
  ColorModel _color;

  switch (colorModel) {
    case _ColorModels.cmyk:
      _color = CmykColor.fromColor(color);
      break;
    case _ColorModels.hsi:
      _color = HsiColor.fromColor(color);
      break;
    case _ColorModels.hsl:
      _color = HslColor.fromColor(color);
      break;
    case _ColorModels.hsp:
      _color = HspColor.fromColor(color);
      break;
    case _ColorModels.hsb:
      _color = HsbColor.fromColor(color);
      break;
    case _ColorModels.lab:
      _color = LabColor.fromColor(color);
      break;
    case _ColorModels.rgb:
      _color = RgbColor.fromColor(color);
      break;
    case _ColorModels.xyz:
      _color = XyzColor.fromColor(color);
      break;
  }

  return _color;
}

num _interpolateValue(num value1, num value2, double step) =>
    ((((1 - step) * value1) + (step * value2)) * 1000000).round() / 1000000;

/// Rounds [value] to the millionth.
num _round(num value) => (value * 1000000).round() / 1000000;
