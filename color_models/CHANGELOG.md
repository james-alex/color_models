## [2.0.0] - September 5, 2024

* Added support for Flutter 3.x wide gamut changes. This necessitated changing
  the `withValues()` method of ColorModel to become `fromValues()` because
  dart:ui Color now has a conflicting withValues() method.  Color also now
  has `r`, `g`, `b` and `a` getters.  This forced changing of the `LabColor`
  and `OklabColor` classes.
  `LabColor` and `OklabColor` had to have the chromaticity members `a` and `b`
  were changed to `chromaticityA` and `chromaticityB`.

## [1.3.3] - January 18, 2023

* Added the [getColorAt] extension methods.

* Added the [rotateHueRad] method to each color model.

* Added the [convertTo] method.

## [1.3.2] - July 20, 2022

* Added the [seed] parameter to the [random] constructors.

## [1.3.1] - July 17, 2022

* Added the [colorSpace] parameter to the [lerpTo] methods.

## [1.3.0] - January 8, 2022

* Added the [chroma] getter and [withChroma] methods.

* Removed all deprecated methods from the package, excluding
[withAlpha] which is no longer deprecated.

* Updated the license from a BSD 2-Clause license to a BSD 3-Clause license.

## [1.2.1] - March 21, 2021

* Extend [ColorSpace] with the [fromList] method.

## [1.2.0] - March 18, 2021

* Renamed [augment]'s [reversed] parameter to [invert].

* Fixed the behavior of [invert].

## [1.1.0] - March 15, 2021

* Implemented the Oklab color space as [OklabColor].

* Added the [castTo], [convert], [copyWith], [interpolate], and
[withValues] methods to every color model.

* Deprecated the `withXXX` methods being replaced by the [copyWith] method.

* Updated the implementation of the [lerpTo] methods.

* Added the [ColorSpace] enumeration and extended it with the [from] method
to convert colors to the color spaces defined by the enumeration.

* Extended `Iterable<ColorModel>` with the [augment] method, which generates
new color palettes derived from the iterable.

## [1.0.0] - March 11, 2021

* Migrated to null-safe code.

* Moved the [calculateDistance], [random], [randomHue] and [round]
utility methods into a utility class: [ColorMath].

* Changed [ColorModel]'s [alpha] parameter from a positional parameter
to a named parameter with a default value of `255`.

## [0.3.0] - September 21, 2020

* Normalized all [alpha] values to be on a `0` to `255` scale to be in line
with Flutter's [Color] class. They were on a `0` to `1` scale.

* Renamed [HsvColor] to [HsbColor] to avoid a naming conflict with Flutter's
[Color] class's [value] parameter.

* Renamed [interpolateTo] to [lerpTo].

## [0.2.8] - March 29, 2020

* Removed [isBlack] and [isWhite] conversion condition from the CMYK color space.

* Added [isMonochromatic] conversion condition to the H color spaces.

* Rounding error fix calculating hues from [XyzColor]s. Affected some colors with
RGB values equaling `255`.

## [0.2.7] - March 29, 2020

* Added the [interpolateTo] method to each color model.

* Override the conversion methods on each color model that return their own
respective color spaces. Colors were being unnecessarily converted back and
forth from RGB.

## [0.2.6] - March 24, 2020

* Added the random factory constructor to each [ColorModel].

* The equality operator and some getters now rounds values to the millionth due
to the slight loss of precision during conversions.

* The [hue] getter now calculates hues directly from RGB,
rather than doing a full conversion to HSL.

* Added the [isMonochromatic] getter to each [ColorModel].

## [0.2.5+1] - March 23, 2020

* Fixed a bug in the HSP to RGB conversion method.

## [0.2.5] - March 22, 2020

* Added the [relative] parameter to the [warmer] and [cooler] methods.

## [0.2.4+2] - March 22, 2020

* Added the [saturation] getter to [ColorModel].

## [0.2.4+1] - March 22, 2020

* Added the [hue] getter to [ColorModel].

## [0.2.4] - March 21, 2020

* Added the [inverted] and [opposite] getters, as well as the [warmer],
[cooler], [rotateHue], and [withHue] methods to each [ColorModel].

## [0.2.3] - March 18, 2020

* Added [alpha] values to all [ColorModel]s.

* Added `withValue` methods to all [ColorModel]s.

## [0.2.2] - March 16, 2020

* Added [hex] getter to [ColorModel].

* Added [fromHex] static method to all [ColorModel]s.

* All [ColorModel]s are now `@immutable`.

## [0.2.1] - January 15, 2020

* All [ColorModel]s now `@override` the `toString()` method.

## [0.2.0+1] - January 15, 2020

* Documentation and formatting changes.

## [0.2.0] - January 4, 2020

* To provide better support for 3rd party color models, [ColorModel]s are now requried to `@override` the
[toRgbColor] method. All [ColorModel]s included in this library still use the color conversion
methods found in the [ColorConverter] helper class, but the methods are now public.

## [0.1.2] - July 31, 2019

* All [ColorModel]s now `@override` [hashCode].

## [0.1.1] - July 25, 2019

* Added a private constructor to the [ColorConverter] class.

* Minor formatting changes.

## [0.1.0] - July 23, 2019

* Initial release
