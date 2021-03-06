import 'package:test/test.dart';
import 'package:color_models/color_models.dart';

/// A set of colors containing black, white, grey, red, green,
/// blue, yellow, cyan, pink, 6 colors that fall into each part
/// of the hue spectrum, and 4 LAB colors that fall outside of
/// the sRGB color space's bounds.
const List<ColorModel> _testColors = <ColorModel>[
  RgbColor(0, 0, 0), // Black
  RgbColor(144, 144, 144), // Grey
  RgbColor(255, 255, 255), // White
  RgbColor(255, 0, 0), // red
  RgbColor(0, 255, 0), // green
  RgbColor(0, 0, 255), // blue
  RgbColor(255, 255, 0), // yellow
  RgbColor(0, 255, 255), // cyan
  RgbColor(255, 0, 255), // pink
  RgbColor(240, 111, 12), // Hue 26°
  RgbColor(102, 204, 51), // Hue 101°
  RgbColor(51, 204, 153), // Hue 161°
  RgbColor(12, 102, 153), // Hue 201°
  RgbColor(120, 42, 212), // Hue 267°
  RgbColor(209, 16, 110), // Hue 331°
  RgbColor(0, 49, 66),
  LabColor(100, 127, 127),
  LabColor(100, -128, -128),
  LabColor(60, 127, -128),
  LabColor(0, -128, 127),
];

/// Each of the color models' types.
enum _ColorModels { cmyk, hsi, hsl, hsp, hsb, lab, rgb, xyz }

/// The following tests convert each of the test colors from RGB
/// to each of the other color spaces. They are then converted
/// back to the RGB color space and are expected to equal the
/// original RGB color value.
void main() {
  group('Color Conversions', () {
    test('CMYK Conversions', () {
      for (var color in _testColors) {
        final cmykColor = color.toCmykColor();
        expect(color.equals(cmykColor), equals(true));
      }
    });

    test('HSI Conversions', () {
      for (var color in _testColors) {
        final hsiColor = color.toHsiColor();
        expect(color.equals(hsiColor), equals(true));
      }
    });

    test('HSL Conversions', () {
      for (var color in _testColors) {
        final hslColor = color.toHslColor();
        expect(color.equals(hslColor), equals(true));
      }
    });

    test('HSP Conversions', () {
      for (var color in _testColors) {
        final hspColor = color.toHspColor();
        expect(color.equals(hspColor), equals(true));
      }
    });

    test('HSB Conversions', () {
      for (var color in _testColors) {
        final hsbColor = color.toHsbColor();
        expect(color.equals(hsbColor), equals(true));
      }
    });

    test('LAB Conversions', () {
      for (var color in _testColors) {
        final labColor = color.toLabColor();
        expect(color.equals(labColor), equals(true));
      }
    });

    test('XYZ Conversions', () {
      for (var color in _testColors) {
        final xyzColor = color.toXyzColor();
        expect(color.equals(xyzColor), equals(true));
      }
    });

    test('Chained Conversions', () {
      for (var color in _testColors) {
        // Don't bother testing non-RGB colors here. Because
        // of a loss of precision when converting colors back
        // and forth between color spaces, they will never equal
        // the original color exactly without being rounded.
        if (color.runtimeType != RgbColor) return;

        var copy = color;

        final cmykColor = CmykColor.from(copy);
        copy = cmykColor.toRgbColor();
        expect(copy, equals(color));

        final hsiColor = HsiColor.from(copy);
        copy = hsiColor.toRgbColor();
        expect(copy, equals(color));

        final hslColor = HslColor.from(copy);
        copy = hslColor.toRgbColor();
        expect(copy, equals(color));

        final hspColor = HspColor.from(copy);
        copy = hspColor.toRgbColor();
        expect(copy, equals(color));

        final hsbColor = HsbColor.from(copy);
        copy = hsbColor.toRgbColor();
        expect(copy, equals(color));

        final labColor = LabColor.from(copy);
        copy = labColor.toRgbColor();
        expect(copy, equals(color));

        final xyzColor = XyzColor.from(copy);
        copy = xyzColor.toRgbColor();
        expect(copy, equals(color));
      }
    });
  });

  group('Color Adjustments', () {
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
                  : _toColorModel(colorModel1, color2).toListWithAlpha();

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
                      expect((values[l] - expectedValue).abs() < 0.25,
                          equals(true));
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

    test('Rotate Hues', () {
      for (var color in _testColors) {
        color = color.toRgbColor();

        final adjustment = 360 / 30;

        var copy = color;

        for (var i = 0; i < 30; i++) {
          copy = copy.rotateHue(adjustment);
        }

        expect(copy, equals(color));
      }
    });
  });
}

/// Converts [color] to the color space defined by [colorModel].
ColorModel _toColorModel(_ColorModels colorModel, ColorModel color) {
  switch (colorModel) {
    case _ColorModels.cmyk:
      color = color.toCmykColor();
      break;
    case _ColorModels.hsi:
      color = color.toHsiColor();
      break;
    case _ColorModels.hsl:
      color = color.toHslColor();
      break;
    case _ColorModels.hsp:
      color = color.toHspColor();
      break;
    case _ColorModels.hsb:
      color = color.toHsbColor();
      break;
    case _ColorModels.lab:
      color = color.toLabColor();
      break;
    case _ColorModels.rgb:
      color = color.toRgbColor();
      break;
    case _ColorModels.xyz:
      color = color.toXyzColor();
      break;
  }

  return color;
}

num _interpolateValue(num value1, num value2, double step) =>
    ((((1 - step) * value1) + (step * value2)) * 1000000).round() / 1000000;

/// Rounds [value] to the millionth.
num _round(num value) => (value * 1000000).round() / 1000000;
