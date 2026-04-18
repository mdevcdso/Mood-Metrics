enum Period {
  week(7, '7 jours'),
  month(30, '30 jours'),
  months(90, '90 jours');

  final int value;
  final String label;

  const Period(this.value, this.label);
}