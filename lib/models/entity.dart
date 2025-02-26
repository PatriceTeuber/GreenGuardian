class Entity {
  int maxLP;
  int currentLP;
  int level;

  Entity({required this.maxLP, required this.currentLP, required this.level});

  double get getProgress {
    // Fortschritt in % zurückgeben
    return double.parse((currentLP/maxLP).toStringAsFixed(2));
  }
}