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
