class Plant {
  final String id;
  final String name;
  final String type;
  final String imagePath; // URL zum Bild
  final int wateringIntervalDays; // z.B. alle 3 Tage gießen
  DateTime lastWatered; // Zeitpunkt der letzten Bewässerung

  Plant({
    required this.id,
    required this.name,
    required this.type,
    required this.imagePath,
    required this.wateringIntervalDays,
    required this.lastWatered,
  });

  // Berechnet, wie viele Tage noch bis zum nächsten Gießen verbleiben.
  int get daysUntilNextWatering {
    final nextWatering = lastWatered.add(Duration(days: wateringIntervalDays));
    final difference = nextWatering.difference(DateTime.now()).inDays;
    return difference;
  }
}
