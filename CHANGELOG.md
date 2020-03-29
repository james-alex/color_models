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
