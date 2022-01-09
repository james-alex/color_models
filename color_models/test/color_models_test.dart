import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:color_models/color_models.dart';
import 'package:num_utilities/num_utilities.dart';

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

    test('Oklab Conversions', () {
      for (var color in _testColors) {
        final oklabColor = color.toOklabColor();
        expect(color.equals(oklabColor), equals(true));
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

        for (var colorSpace in ColorSpace.values) {
          final convertedColor = colorSpace.from(copy);
          copy = convertedColor.toRgbColor();
          expect(copy, equals(color));
        }
      }
    });
  });

  group('Color Adjustments', () {
    test('Interpolate', () {
      for (var i = 0; i < _testColors.length; i++) {
        for (var j = 0; j < _testColors.length; j++) {
          for (var colorModel1 in ColorSpace.values) {
            final color1 = colorModel1.from(_testColors[i]);
            final values1 = color1 is RgbColor
                ? color1.toPreciseListWithAlpha()
                : color1.toListWithAlpha();

            for (var colorModel2 in ColorSpace.values) {
              final color2 = colorModel2.from(_testColors[j]);
              final values2 = color1 is RgbColor
                  ? color2.toRgbColor().toPreciseListWithAlpha()
                  : colorModel1.from(color2).toListWithAlpha();

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
                        ? values2[l].roundToPrecision(6)
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

  test('Chroma Calculations', () {
    // Generate a gradient of 101 OklabColors ranging from black to white.
    final gradient = List<OklabColor>.generate(101, (index) {
      final lightness = index / 100;
      final linearizedLightness =
          index > 0 ? (1.028 * math.pow(lightness, 1 / 6.9)) - 0.028 : 0;
      return OklabColor(linearizedLightness.toDouble(), 0, 0);
    });

    // Verify the calculated chroma values are intervals of `0.01`
    // and that when passed to the [withChroma] method the calculated
    // lightness value is the same as their original lightness values.
    for (var i = 0; i < gradient.length; i++) {
      final color = gradient[i];
      final chroma = color.chroma.roundToPrecision(6);
      expect(chroma, equals((i * 0.01).roundToPrecision(6)));
      final reverted = color.withChroma(chroma);
      expect(reverted.lightness, equals(color.lightness));
    }
  });
}

num _interpolateValue(num value1, num value2, double step) =>
    (((1 - step) * value1) + (step * value2)).roundToPrecision(6);
