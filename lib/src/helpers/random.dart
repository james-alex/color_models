import 'dart:math' show Random;

/// Generates a random double between [min] and [max].
double random(num min, num max) {
  return (((Random().nextDouble() * (max - min)) + min) * 10).round() / 10;
}

/// Generates a random hue between [min] and [max].
double randomHue(num min, num max) {
  assert(min >= 0 && min <= 360);
  assert(max >= 0 && max <= 360);

  return min <= max
      ? random(min, max)
      : (random(0, (max + 360) - min) + min) % 360;
}
