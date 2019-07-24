# color_models

A Dart plugin for defining color constants and converting them
between color spaces.

For use with Flutter, see:
http://github.com/james-alex/flutter_color_models

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

Altenatively, each color model has a static method `from` that can
accept a color from any color space and returns its own type (T).

```dart
static T from(ColorModel color);
```

```dart
// Create a HSV color
HsvColor originalColor = HsvColor(0.3, 0.8, 0.7);

// Convert it to RGB => RgbColor(64, 179, 36)
RgbColor rgbColor = RgbColor.from(originalColor);

// Then to CMYK => CmykColor(64.25, 0, 79.89, 29.8)
CmykColor cmykColor = CmykColor.from(rgbColor);

// Back to HSV => HsvColor(0.3, 0.8, 0.7)
HsvColor hsvColor = HsvColor.from(cmykColor);
```

__Note:__ All color conversions use the RGB color space as an
intermediary. To minimize the loss of precision when converting
between other color spaces, [RgbColor] privately stores the RGB
values as [num]s rather than [int]s. The [num] values can be
returned as a list with [RgbColor]'s `toPreciseList()` method.
