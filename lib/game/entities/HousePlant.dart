class HousePlant {
  final String name;
  DateTime lastWatered;
  final Duration wateringInterval;

  HousePlant({
    required this.name,
    required this.lastWatered,
    required this.wateringInterval,
  });

  // Prüft, ob die Pflanze innerhalb des Intervalls gegossen wurde.
  bool get isWatered => DateTime.now().difference(lastWatered) < wateringInterval;

  // Methode, um die Pflanze zu gießen
  void water() {
    lastWatered = DateTime.now();
  }
}