class HousePlant {
  final String name;
  DateTime lastWatered;
  final Duration wateringInterval;
  bool attacked;

  HousePlant({
    required this.name,
    required this.lastWatered,
    required this.wateringInterval,
    this.attacked = false,
  });

  // Prüft, ob die Pflanze innerhalb des Intervalls gegossen wurde.
  bool get isWatered => DateTime.now().difference(lastWatered) < wateringInterval;

  // Methode, um die Pflanze zu gießen
  void water() {
    lastWatered = DateTime.now();
    attacked = false;
  }
}