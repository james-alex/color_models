/// Rounds `value * precision`.
///
/// Used by the equality operators for every color model except RGB.
num round(num value, [int precision = 1000000]) => (value * precision).round();
