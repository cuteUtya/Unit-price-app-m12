bool useDarkTheme = true;

int getToneOfColor(int lightTone) {
  if(!useDarkTheme) return lightTone;

  return {
    100: 0,
    99: 10,
    95: 20,
    90: 30,
    80: 40,
    70: 50,
    60: 60,
    50: 70,
    40: 80,
    30: 90,
    20: 95,
    10: 99,
    0: 100,
  }[lightTone]!;
}