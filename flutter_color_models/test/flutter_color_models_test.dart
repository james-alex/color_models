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

    test('Oklab Conversions', () {
      for (var color in _testColors) {
        final rgbColor = RgbColor.fromColor(color);
        final oklabColor = rgbColor.toOklabColor();
        expect(rgbColor.equals(oklabColor), equals(true));
        expect(oklabColor.toColor(), equals(color));
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

        for (var colorSpace in ColorSpace.values) {
          final convertedColor = colorSpace.fromColor(copy);
          copy = convertedColor.toColor();
          expect(copy, equals(color));
        }
      }
    });
  });

  test('Random Constructors', () {
    final seed = DateTime.now().millisecond;
    CmykColor.random(seed: seed);
    HsbColor.random(seed: seed);
    HsiColor.random(seed: seed);
    HslColor.random(seed: seed);
    HspColor.random(seed: seed);
    LabColor.random(seed: seed);
    OklabColor.random(seed: seed);
    RgbColor.random(seed: seed);
    XyzColor.random(seed: seed);
  });
}
