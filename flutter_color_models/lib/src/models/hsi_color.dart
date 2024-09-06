import 'dart:ui' as ui;
import 'package:flutter/painting.dart' show Color;
import 'package:color_models/color_models.dart' as cm;
import '../color_model.dart';
import 'helpers/as_color.dart';
import 'helpers/rgb_getters.dart';
import 'helpers/cast_to_color.dart';

/// {@macro color_models.HsiColor}
class HsiColor extends cm.HsiColor
    with AsColor, RgbGetters, CastToColor
    implements ColorModel {
  /// {@macro color_models.HsiColor.constructor}
  const HsiColor(
    num hue,
    num saturation,
    num intensity, [
    int alpha = 255,
  ])  : assert(hue >= 0 && hue <= 360),
        assert(saturation >= 0 && saturation <= 100),
        assert(intensity >= 0 && intensity <= 100),
        assert(alpha >= 0 && alpha <= 255),
        super(hue, saturation, intensity, alpha);

  @override
  int get value => toColor().value;

  @override
  HsiColor interpolate(cm.ColorModel end, double step) {
    assert(step >= 0.0 && step <= 1.0);
    return super.interpolate(end, step).cast();
  }

  @override
  List<HsiColor> lerpTo(
    cm.ColorModel color,
    int steps, {
    cm.ColorSpace? colorSpace,
    bool excludeOriginalColors = false,
  }) {
    assert(steps > 0);
    return super
        .lerpTo(color, steps,
            colorSpace: colorSpace,
            excludeOriginalColors: excludeOriginalColors)
        .map<HsiColor>((color) => color.cast())
        .toList();
  }

  @override
  HsiColor get inverted => super.inverted.cast();

  @override
  HsiColor get opposite => super.opposite.cast();

  @override
  HsiColor rotateHue(num amount) => super.rotateHue(amount).cast();

  @override
  HsiColor rotateHueRad(double amount) => super.rotateHueRad(amount).cast();

  @override
  HsiColor warmer(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.warmer(amount, relative: relative).cast();
  }

  @override
  HsiColor cooler(num amount, {bool relative = true}) {
    assert(amount > 0);
    return super.cooler(amount, relative: relative).cast();
  }

  @override
  HsiColor withHue(num hue) {
    assert(hue >= 0 && hue <= 360);
    return HsiColor(hue, saturation, intensity, alpha);
  }

  @override
  HsiColor withChroma(double chroma) => super.withChroma(chroma).cast();

  @override
  HsiColor withRed(num red) {
    assert(red >= 0 && red <= 255);
    return toRgbColor().withRed(red).toHsiColor();
  }

  @override
  HsiColor withGreen(num green) {
    assert(green >= 0 && green <= 255);
    return toRgbColor().withGreen(green).toHsiColor();
  }

  @override
  HsiColor withBlue(num blue) {
    assert(blue >= 0 && blue <= 255);
    return toRgbColor().withBlue(blue).toHsiColor();
  }

  @override
  HsiColor withAlpha(int alpha) {
    assert(alpha >= 0 && alpha <= 255);
    return HsiColor(hue, saturation, intensity, alpha);
  }

  @override
  HsiColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return copyWith(alpha: (opacity * 255).round());
  }

  // We must override this withValues from Color, has this from dart ui
  /// Returns a new color that matches this color with the passed in components
  /// changed.
  ///
  /// Changes to color components will be applied before applying changes to the
  /// color space.
  Color withValues(
      {double? alpha,
      double? red,
      double? green,
      double? blue,
      ui.ColorSpace? colorSpace}) {
    Color? updatedComponents;
    if (alpha != null || red != null || green != null || blue != null) {
      updatedComponents = Color.from(
          alpha: alpha ?? a,
          red: red ?? r,
          green: green ?? g,
          blue: blue ?? b,
          colorSpace: this.colorSpace);
    }
    if (colorSpace != null && colorSpace != this.colorSpace) {
      final UICloned_ColorTransform transform =
          UICloned_getColorTransform(this.colorSpace, colorSpace);
      return transform.transform(updatedComponents ?? this, colorSpace);
    } else {
      return updatedComponents ?? this;
    }
  }
  
  @override
  HsiColor withValuesList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    return HsiColor.fromList(values);
  }

  @override
  HsiColor copyWith({num? hue, num? saturation, num? intensity, int? alpha}) {
    assert(hue == null || (hue >= 0 && hue <= 360));
    assert(saturation == null || (saturation >= 0 && saturation <= 100));
    assert(intensity == null || (intensity >= 0 && intensity <= 100));
    assert(alpha == null || (alpha >= 0 && alpha <= 255));
    return HsiColor(
      hue ?? this.hue,
      saturation ?? this.saturation,
      intensity ?? this.intensity,
      alpha ?? this.alpha,
    );
  }

  @override
  HsiColor toHsiColor() => this;

  /// {@macro color_models.HsiColor.from}
  factory HsiColor.from(cm.ColorModel color) => color.toHsiColor().cast();

  /// {@macro color_models.HsiColor.fromList}
  factory HsiColor.fromList(List<num> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 360);
    assert(values[1] >= 0 && values[1] <= 100);
    assert(values[2] >= 0 && values[2] <= 100);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 255);
    final alpha = values.length == 4 ? values[3].round() : 255;
    return HsiColor(values[0], values[1], values[2], alpha);
  }

  /// Constructs a [HsiColor] from [color].
  factory HsiColor.fromColor(Color color) =>
      RgbColor.fromColor(color).toHsiColor();

  /// {@macro color_models.HsiColor.fromHex}
  factory HsiColor.fromHex(String hex) => cm.HsiColor.fromHex(hex).cast();

  /// {@macro color_models.HsiColor.extrapolate}
  factory HsiColor.extrapolate(List<double> values) {
    assert(values.length == 3 || values.length == 4);
    assert(values[0] >= 0 && values[0] <= 1);
    assert(values[1] >= 0 && values[1] <= 1);
    assert(values[2] >= 0 && values[2] <= 1);
    if (values.length == 4) assert(values[3] >= 0 && values[3] <= 1);
    final alpha = values.length == 4 ? (values[3] * 255).round() : 255;
    return HsiColor(values[0] * 360, values[1] * 100, values[2] * 100, alpha);
  }

  /// {@macro color_models.HsiColor.random}
  factory HsiColor.random({
    num minHue = 0,
    num maxHue = 360,
    num minSaturation = 0,
    num maxSaturation = 100,
    num minIntensity = 0,
    num maxIntensity = 100,
    int? seed,
  }) {
    assert(minHue >= 0 && minHue <= 360);
    assert(maxHue >= 0 && maxHue <= 360);
    assert(minSaturation >= 0 && minSaturation <= maxSaturation);
    assert(maxSaturation >= minSaturation && maxSaturation <= 100);
    assert(minIntensity >= 0 && minIntensity <= maxIntensity);
    assert(maxIntensity >= minIntensity && maxIntensity <= 100);
    return cm.HsiColor.random(
      minHue: minHue,
      maxHue: maxHue,
      minSaturation: minSaturation,
      maxSaturation: maxSaturation,
      minIntensity: minIntensity,
      maxIntensity: maxIntensity,
      seed: seed,
    ).cast();
  }

  @override
  HsiColor convert(cm.ColorModel other) => other.toHsiColor().cast();

  //OVERRIDEs for painting.dart Color
  @override
  double get a => (alpha / 255);

  /// The red channel of this color.
  @override
  double get r =>(red / 255);

  /// The green channel of this color.
  @override
  double get g => (green / 255);

  /// The blue channel of this color.
  @override
  double get b => (blue / 255);

  /// The color space of this color.
  @override
  final ui.ColorSpace colorSpace=ui.ColorSpace.sRGB;
}
