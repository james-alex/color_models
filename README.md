# color_models

[![pub package](https://img.shields.io/pub/v/color_models.svg)](https://pub.dartlang.org/packages/color_models)

A package with models for defining colors in the CMYK, HSI, HSL, HSP, HSB,
LAB, RGB, and XYZ color spaces, with methods for converting colors between
spaces and adjusting their properties.

__For use with Flutter, see:__ https://pub.dev/packages/flutter_color_models

Check out [palette](https://pub.dev/packages/palette), a package for creating,
generating, and modifying color palettes.

# Usage

```dart
import 'package:color_models/color_models.dart';
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

## Converting Colors Between Spaces

Each color model has methods to convert itself to every other color model.

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

Altenatively, each color model has a constructor [ColorModel.from] that returns
a color from any color space in the color space being called.

```dart
// Create a HSB color
var originalColor = HsbColor(0.3, 0.8, 0.7);

// Convert it to RGB => RgbColor(64, 179, 36)
var rgbColor = RgbColor.from(originalColor);

// Then to CMYK => CmykColor(64.25, 0, 79.89, 29.8)
var cmykColor = CmykColor.from(rgbColor);

// Back to HSB => HsbColor(0.3, 0.8, 0.7)
var hsbColor = HsbColor.from(cmykColor);
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
