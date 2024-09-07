## [2.0.0] - September 5, 2024

* Added support for Flutter 3.x wide gamut changes. This necessitated changing 
  the `withValues()` method of ColorModel to become `fromValues()`
  because dart:ui Color now has a conflicting withValues() method.  Color also
  now has `r`, `g`, `b` and `a` getters.  This forced changing of the
  `LabColor` and `OklabColor` classes.
  addition of `withValues()` override method to `CmykColor`, `HsbColor`,
  `HsiColor`, `HslColor`, `HspColor`, `LabColor`,
  `OklabColor`, `RgbColor` and `XyzColor` classes so they could continue
   to extend `ColorModel` which implements `ui.Color` (which now
   has this member method)
  `LabColor` and `OklabColor` had to have the chromaticity members `a`
  and `b` were changed to `chromaticityA` and `chromaticityB`
  Addition of `a`, `r`, `g`, `b` and `colorSpace` getters to continue to
  support extending `ui.Color`
* add factory constructor to `ColorModel` that takes a `ui.Color` object
  (so `Colors.XXXX` could be used in creating `ColorModel`s
  
## [1.3.3] - January 18, 2023

* Added the [toColors] helper method to [Iterable<ColorModel>].

* Added the [interpolate] extension method to [Color].

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

* Extend [Color] with the [toColorModel] method.

* Extend `Iterable<Color>` with the [toColorModels] method.

## [1.2.0] - March 18, 2021

* Renamed [augment]'s [reversed] parameter to [invert].

* Fixed the behavior of [invert].

## [1.1.1+1] - March 18, 2021

* Extended [Color] with the [toOklabColor] method.

## [1.1.1] - March 18, 2021

* Added the [reversed] parameter to [augment].

## [1.1.0+1] - March 17, 2021

* Fixed bug causing RGBs to lose their precision when cast to/from
the [RgbColor] object from `color_models`.

## [1.1.0] - March 15, 2021

* Implemented the Oklab color space as [OklabColor].

* Added the [castTo], [convert], [copyWith], [interpolate], and
[withValues] methods to every color model.

* Deprecated the `withXXX` methods being replaced by the [copyWith] method.

* Updated the implementation of the [lerpTo] methods.

* Added the [ColorSpace] enumeration and extended it with the [from] and
[fromColor] methods to convert colors to the color spaces defined by the
enumeration.

* Extended `Iterable<Color>` and `Iterable<ColorModel>` with the [augment]
method, which generates new color palettes derived from the iterable.

* Override every relevant method/getter on [ColorModel] to return the
objects defined in `flutter_color_models`, rather than the ones beloning
to `color_models`.

## [1.0.0] - March 11, 2021

* Migrated to null-safe code.

* Extended [Color] with methods to convert it to all of
the [ColorModel]s in this package.

## [0.3.3] - October 6, 2020

* Updated all methods on each color model that rely on their parent's equivalent
method to call their super method, rather than casting back and forth between types,
where applicable.

## [0.3.2] - October 6, 2020

* Bug fix: The [from] constructors now copy the alpha value from the color
they're being constructed from.

## [0.3.1] - October 6, 2020

* Re-implemented the [toColor] method.

## [0.3.0] - October 4, 2020

* Created a new base [ColorModel] class that implements [Color] that each of the models
now implement. Before, this packages [ColorModel]s extended the color_models package's
[ColorModel] class and implemented [Color] individually. Now, this package's [ColorModel]s
can be provided as a [Color] without needing to typecast them first.

## [0.2.0] - September 21, 2020

* All color models now implement Flutter's [Color] class.

* Normalized all [alpha] values to be on a `0` to `255` scale to be in line
with Flutter's [Color] class. They were on a `0` to `1` scale.

* Renamed [HsvColor] to [HsbColor] to avoid a naming conflict with Flutter's
[Color] class's [value] parameter.

* Renamed [interpolateTo] to [lerpTo].

## [0.1.6] - March 29, 2020

* Added the [interpolateTo] method to each color model.

* Override the conversion methods on each color model that return their own
respective color spaces. Colors were being unnecessarily converted back and
forth from RGB.

## [0.1.5+1] - March 27, 2020

* Added the global [toColor] method.

## [0.1.5] - March 24, 2020

* Added the random factory constructor to each [ColorModel].

* The equality operator and some getters now rounds values to the millionth due
to the slight loss of precision during conversions.

* The [hue] getter now calculates hues directly from RGB,
rather than doing a full conversion to HSL.

* Added the [isMonochromatic] getter to each [ColorModel].

## [0.1.4+1] - March 23, 2020

* Fixed a bug and corrected rounding errors in HSP to RGB conversion.

## [0.1.4] - March 22, 2020

* Added the [relative] parameter to the [warmer] and [cooler] methods.

## [0.1.3+2] - March 22, 2020

* Added the [saturation] getter to [ColorModel].

## [0.1.3+1] - March 22, 2020

* Added the [hue] getter to [ColorModel].

## [0.1.3] - March 21, 2020

* Added the [inverted] and [opposite] getters, as well as the [warmer],
[cooler], [rotateHue], and [withHue] methods to each [ColorModel].

## [0.1.2] - March 18, 2020

* Added support for [alpha] values and related methods to each of the [ColorModel]s.

## [0.1.1+1] - March 17, 2020

* Updated the color_models package to version 0.2.2+3.

## [0.1.1] - March 16, 2020

* Updated the color_models package to version 0.2.2+2.

* Added the [fromHex] static method to each of the [ColorModel]s.

## [0.1.0+2] - January 15, 2019

* Updated the color_models package to version 0.2.1+2.

* Documentation and formatting changes.

## [0.1.0] - July 23, 2019

* Initial release
