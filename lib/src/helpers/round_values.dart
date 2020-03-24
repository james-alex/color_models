/// Rounds the [value] to the [precision]th.
num round(num value, [int precision = 1000000]) =>
    (value * precision).round() / precision;
