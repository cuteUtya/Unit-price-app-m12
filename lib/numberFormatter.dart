String formatNumber(double value) {
  return value.toStringAsFixed(2).replaceAll('.00', '').replaceAll(',00', '');
}