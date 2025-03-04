import 'package:green_guardian/models/PlantInfo.dart';

class Plant {
  final int id;
  final String imagePath;
  late PlantInfo plantInfo;
  DateTime nextWateringDate = DateTime.now().subtract(Duration(days: 1));
  DateTime lastWatered = DateTime.now().subtract(Duration(days: 1));
  bool attacked;

  Plant({
    required this.attacked,
    required this.id,
    required this.imagePath,
    required this.plantInfo
  }) {
    nextWateringDate = getNextWateringDayDate(plantInfo);
  }

  int getDaysUntilWatering() {
    DateTime now = DateTime.now();
    if (nextWateringDate.isAfter(now)) {
      return nextWateringDate.difference(now).inDays;
    } else {
      return 0;
    }
  }

  bool get isOverdue {
    DateTime now = DateTime.now();
    // Wenn jetzt nach dem geplanten Gießzeitpunkt liegt und lastWatered vor dem geplanten Zeitpunkt ist,
    // wurde die Pflanze noch nicht an diesem Tag gegossen.
    return now.isAfter(nextWateringDate) && lastWatered.isBefore(nextWateringDate);
  }

  DateTime getNextWateringDayDate(PlantInfo plantInfo) {
    DateTime now = lastWatered;
    final Map<String, int> dayToIndex = {
      "Montag": 1,
      "Dienstag": 2,
      "Mittwoch": 3,
      "Donnerstag": 4,
      "Freitag": 5,
      "Samstag": 6,
      "Sonntag": 7,
    };

    List<int> wateringIndices = plantInfo.wateringDays
        .map((day) => dayToIndex[day])
        .whereType<int>()
        .toList();

    if (wateringIndices.isEmpty) {
      return now;
    }
    wateringIndices.sort();

    int currentWeekday = now.weekday;
    int? nextDayIndex;

    for (int index in wateringIndices) {
      if (index > currentWeekday) {
        nextDayIndex = index;
        break;
      }
    }

    int daysToAdd;
    if (nextDayIndex != null) {
      daysToAdd = nextDayIndex - currentWeekday;
    } else {
      daysToAdd = (7 - currentWeekday) + wateringIndices.first;
    }

    return now.add(Duration(days: daysToAdd));
  }



}
