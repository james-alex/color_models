# color_models

A Dart & Flutter package for defining color constants and converting them
between color spaces.

# Usage

```dart
import 'package:color_models/color_models.dart';
```

__For use with Flutter:__

```dart
import 'package:color_models/flutter_color_models.dart';
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

# Flutter

```dart
import 'package:color_models/flutter_color_models.dart';
```

The flutter_color_models library exposes an API identical to the one detailed
in the 'Usage' section above, plus 2 additional methods to each color model:
`toColor()` and `fromColor()`.

The `toColor()` method returns the color as Flutter's [Color] class.

The static `fromColor(Color color)` method will return [color] in the
color space being called, converting the color from RGB if necessary.

```dart
static T fromColor(Color color);
```

```dart
var color = Color(0xFF00FFFF);

var cmyk = CmykColor.fromColor(color); // CmykColor(100.0, 0.0, 0.0, 0.0)

color = cmyk.toColor(); // Color(0xFF00FFFF)

var hsi = HsiColor.fromColor(color); // HsiColor(180.0, 100.0, 66.66666666666666)

color = hsi.toColor(); // Color(0xFF00FFFF)

var hsl = HslColor.fromColor(color); // HslColor(180.0, 100.0, 50.0)

color = hsl.toColor(); // Color(0xFF00FFFF)

var hsp = HspColor.fromColor(color); // HspColor(180.0, 100.0 83.72574275573791)

color = hsp.toColor(); // Color(0xFF00FFFF)

var hsv = HsvColor.fromColor(color); // HsvColor(180.0, 100.0, 100.0)

color = hsv.toColor(); // Color(0xFF00FFFF)

var lab = LabColor.fromColor(color); // LabColor(91.11304514653253, -48.087218639657145, -14.131691287926639)

color = lab.toColor(); // Color(0xFF00FFFF)

var rgb = RgbColor.fromColor(color); // RgbColor(0, 255, 255)

color = rgb.toColor(); // Color(0xFF00FFFF)

var xyz = XyzColor.fromColor(color); // XyzColor(56.611265443396015, 78.73609941284886, 98.22499599290273)

color = xyz.toColor(); // Color(0xFF00FFFF)
```
