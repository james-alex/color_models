import 'dart:math' show Random;
import 'package:num_utilities/num_utilities.dart';

class ColorMath {
  ColorMath._();

  /// Calculates the distance between [hue1] and [hue2].
  static num calculateDistance(num hue1, num hue2) {
    assert(hue1 >= 0 && hue1 <= 360);
    assert(hue2 >= 0 && hue2 <= 360);
    final distance1 = hue1 > hue2 ? hue1 - hue2 : hue2 - hue1;
    final distance2 = hue1 > hue2 ? (hue2 + 360) - hue1 : (hue1 + 360) - hue2;
    return distance1 < distance2 ? distance1 : distance2;
  }

  /// Generates a random double between [min] and [max] rounded to the tenth.
  static double random(num min, num max, [int? seed]) =>
      (((Random(seed).nextDouble() * (max - min)) + min) * 10).round() / 10;

  /// Generates a random hue between [min] and [max].
  static double randomHue(num min, num max, [int? seed]) {
    assert(min >= 0 && min <= 360);
    assert(max >= 0 && max <= 360);
    return min <= max
        ? random(min, max, seed)
        : (random(0, (max + 360) - min, seed) + min) % 360;
  }

  /// Rounds [value] to the millionth.
  static num round(num value) => value.roundTo(1000000);
}
