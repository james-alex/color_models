/// Calculates the distance between [hue1] and [hue2].
num calculateDistance(num hue1, num hue2) {
  assert(hue1 != null && hue1 >= 0 && hue1 <= 360);
  assert(hue2 != null && hue2 >= 0 && hue2 <= 360);

  final distance1 = hue1 > hue2 ? hue1 - hue2 : hue2 - hue1;
  final distance2 = hue1 > hue2 ? (hue2 + 360) - hue1 : (hue1 + 360) - hue2;

  return distance1 < distance2 ? distance1 : distance2;
}
