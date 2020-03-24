import 'dart:math' show Random;

/// Generates a random double between [min] and [max].
double random(num min, num max) {
  assert(min != null);
  assert(max != null);

  return (((Random().nextDouble() * (max - min)) + min) * 10).round() / 10;
}

/// Generates a random hue between [min] and [max].
double randomHue(num min, num max) {
  assert(min != null && min >= 0 && min <= 360);
  assert(max != null && max >= 0 && max <= 360);

  return random(min, max) % 360;
}
