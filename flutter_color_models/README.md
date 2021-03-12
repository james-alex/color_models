# flutter_color_models

[![pub package](https://img.shields.io/pub/v/flutter_color_models.svg)](https://pub.dartlang.org/packages/flutter_color_models)

A wrapper for the color_models plugin that implements Flutter's [Color] class.

__For use without Flutter, see:__ https://pub.dev/packages/color_models

Check out [flutter_palette](https://pub.dev/packages/flutter_palette),
a package for creating, generating, and modifying color palettes.

## Usage

```dart
import 'package:flutter_color_models/flutter_color_models.dart';
```

## Color Spaces

color_models exposes models for the CMYK, HSI, HSL, HSP, HSB, LAB, RGB,
and XYZ color spaces; represented as [CmykColor], [HsiColor], [HslColor],
[HspColor], [HsbColor], [LabColor], [RgbColor], and [XyzColor] respectively.

Each model is constant and extends [ColorModel].

## Creating Colors

Colors can be created by constructing a [ColorModel] directly, or with the
[fromList] or [extrapolate] constructors. [extrapolate] accepts each model's
respective values on a `0` to `1` scale, and extrapolates them to their normal
scale.

Each model posesses values for each property of their respective acronyms,
as well as an optional [alpha] value.

```dart
// Each of the below colors is red at 100% opacity.

// RGB without alpha
RgbColor(255, 0, 0);
RgbColor.fromList(<num>[255, 0, 0]);
RgbColor.extrapolate(<num>[1.0, 0.0, 0.0]);

// RGB with alpha
RgbColor(255, 0, 0, 1.0);
RgbColor.fromList(<num>[255, 0, 0, 255]);
RgbColor.extrapolate(<num>[1.0, 0.0, 0.0, 255]);

// CMYK without alpha
CmykColor(0.0, 100.0, 100.0, 0.0);
CmykColor.fromList(<num>[0.0, 100.0, 100.0, 0.0]);
CmykColor.extrapolate(<num>[0.0, 1.0, 1.0, 0.0]);

// CMYK with alpha
CmykColor(0.0, 100.0, 100.0, 0.0, 1.0);
CmykColor.fromList(<num>[0.0, 100.0, 100.0, 0.0, 255]);
CmykColor.extrapolate(<num>[0.0, 1.0, 1.0, 0.0, 255]);

// HSL without alpha
HslColor(0.0, 100.0, 50.0);
HslColor.fromList(<num>[0.0, 100.0, 50.0]);
HslColor.extrapolate(<num>[0.0, 1.0, 0.5]);

// HSL with alpha
HslColor(0.0, 100.0, 50.0, 1.0);
HslColor.fromList(<num>[0.0, 100.0, 50.0, 255]);
HslColor.extrapolate(<num>[0.0, 1.0, 0.5, 255]);
```

## Casting Color to and from the ColorModels

Each color model has method `toColor()` a static method `fromColor()`
that will cast a [Color] to a [ColorModel] and vice versa, converting
the color to desired color space if not called on [RgbColor].

```dart
Color color = Color(0xFFFFFF00); // yellow

CmykColor cmykColor = CmykColor.fromColor(color);
color = cmykColor.toColor();

HsiColor hsiColor = HsiColor.fromColor(color);
color = hsiColor.toColor();

HslColor hslColor = HslColor.fromColor(color);
color = hslColor.toColor();

HspColor hspColor = HspColor.fromColor(color);
color = hspColor.toColor();

HsvColor hsvColor = HsvColor.fromColor(color);
color = hsvColor.toColor();

LabColor labColor = LabColor.fromColor(color);
color = labColor.toColor();

RgbColor rgbColor = RgbColor.fromColor(color);
color = rgbColor.toColor();

XyzColor xyzColor = XyzColor.fromColor(color);
color = xyzColor.toColor();
```

Due to the nature of this implementation, the base [ColorModel] lacks the
[toColor] method. Instead, the global [toColor] method can be used.

```dart
// Cast a [ColorModel] to a [Color].
var color = toColor(color);
```

## Converting Colors Between Spaces

Each color model has methods to convert itself
to each of the other color models.

```dart
CmykColor toCmykColor();

HsiColor toHsiColor();

HslColor toHslColor();

HspColor toHspColor();

HsbColor toHsbColor();

LabColor toLabColor();

RgbColor toRgbColor();

XyzColor toXyzColor();
```

Altenatively, each color model has a constructor [ColorModel.from] that can
accept a color from any color space and returns its own type (T).

```dart
// Create a HSB color
HsbColor originalColor = HsbColor(0.3, 0.8, 0.7);

// Convert it to RGB => RgbColor(64, 179, 36)
RgbColor rgbColor = RgbColor.from(originalColor);

// Then to CMYK => CmykColor(64.25, 0, 79.89, 29.8)
CmykColor cmykColor = CmykColor.from(rgbColor);

// Back to HSB => HsbColor(0.3, 0.8, 0.7)
HsbColor hsbColor = HsbColor.from(cmykColor);
```

__Note:__ All color conversions use the RGB color space as an
intermediary. To minimize the loss of precision when converting
between other color spaces, [RgbColor] privately stores the RGB
values as [num]s rather than [int]s. The [num] values can be
returned as a list with [RgbColor]'s `toPreciseList()` method.

## Color Adjustments

For convenience, each [ColorModel] has 2 getters, [inverted] and [opposite],
and 3 methods, [cooler], [warmer] and [rotateHue], for generating new colors.

[inverted] inverts the colors properties within their respective ranges,
excluding hue, which is instead rotated 180 degrees.

```dart
final orange = RgbColor(255, 144, 0);

print(orange.inverted); // RgbColor(0, 111, 255);
```

[opposite] returns the color with the hue opposite this. [opposite] is
shorthand for `color.rotateHue(180)`.

[rotateHue] rotates the hue of the color by the [amount] specified in degrees.
Colors in the CMYK, LAB, RGB, and XYZ color spaces will be converted to and from
the HSL color space where the hue will be rotated.

```dart
final orange = RgbColor(255, 144, 0);

print(orange.opposite); // RgbColor(0, 111, 255);

print(orange.rotateHue(30)); // RgbColor(239, 255, 0);

print(orange.rotateHue(-30)); // RgbColor(255, 17, 0);
```

[warmer] and [cooler] will rotate the hue of the color by the [amount] specified
towards `90` degrees and `270` degrees, respectively. The hue's value will be
capped at `90` or `270`.

```dart
final orange = RgbColor(255, 144, 0);

print(orange.warmer(30)); // RgbColor(239, 255, 0);

print(orange.cooler(30)); // RgbColor(255, 17, 0);
```

## Interpolating Between Colors

Each color model has a method, [lerpTo], that calculates a specified number
of steps between `this` color and a color provided to the method, returning all of
the colors inbetween the two colors in a list. Colors will be returned in the color
space of the color the method is called on.

```dart
final color1 = RgbColor(255, 0, 0); // red
final color2 = RgbColor(0, 0, 255); // blue

/// Calculate a [List<RgbColor>] of 5 colors: [color1], [color2] and the 3 steps inbetween.
final colors = color1.lerpTo(color2, 3);

// [RgbColor(255, 0, 0, 255), RgbColor(191, 0, 64, 255), RgbColor(128, 0, 128, 255), RgbColor(64, 0, 191, 255), RgbColor(0, 0, 255, 255)]
print(colors);

/// To return only the steps in between [color1] and [color2], the [excludeOriginalColors] parameter can be set to `true`.
final steps = color1.lerpTo(color2, 3, excludeOriginalColors: true);

// [RgbColor(191, 0, 64, 255), RgbColor(128, 0, 128, 255), RgbColor(64, 0, 191, 255)]
print(steps);
```
