enum Mood {
  veryBad(1, 'Triste'),
  bad(2, 'Fatigué'),
  neutral(3, 'Neutre'),
  good(4, 'Bien'),
  veryGood(5, 'Heureux');

  final int value;
  final String label;

  const Mood(this.value, this.label);
}
