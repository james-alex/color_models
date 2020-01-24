# color_models

[![pub package](https://img.shields.io/pub/v/color_models.svg)](https://pub.dartlang.org/packages/color_models)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)

A Dart & Flutter package for defining color constants and converting them
between color spaces.

For use with Flutter, see:
https://pub.dev/packages/flutter_color_models


# Usage

```dart
import 'package:color_models/color_models.dart';
```

## Color Spaces

color_models exposes models for the CMYK, HSI, HSL, HSP, HSV, LAB, RGB,
and XYZ color spaces; represented as [CmykColor], [HsiColor], [HslColor],
[HspColor], [HsvColor], [LabColor], [RgbColor], and [XyzColor] respectively.

Each model is constant and extends [ColorModel].

## Converting Colors Between Spaces

Each color model has methods to convert itself to every other color model.

```dart
CmykColor toCmykColor();

HsiColor toHsiColor();

HslColor toHslColor();

HspColor toHspColor();

HsvColor toHsvColor();

LabColor toLabColor();

RgbColor toRgbColor();

XyzColor toXyzColor();
```

Altenatively, each color model has a static method `from` that returns
a color from any color space in the color space being called.

```dart
static T from(ColorModel color);
```

```dart
// Create a HSV color
var originalColor = HsvColor(0.3, 0.8, 0.7);

// Convert it to RGB => RgbColor(64, 179, 36)
var rgbColor = RgbColor.from(originalColor);

// Then to CMYK => CmykColor(64.25, 0, 79.89, 29.8)
var cmykColor = CmykColor.from(rgbColor);

// Back to HSV => HsvColor(0.3, 0.8, 0.7)
var hsvColor = HsvColor.from(cmykColor);
```

__Note:__ All color conversions use the RGB color space as an
intermediary. To minimize the loss of precision when converting
between other color spaces, [RgbColor] privately stores the RGB
values as [num]s rather than [int]s. The [num] values can be
returned as a list with [RgbColor]'s `toPreciseList()` method.
