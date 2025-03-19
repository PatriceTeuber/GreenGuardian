import 'package:green_guardian/models/PlantInfo.dart';

class Plant {
  final int id;
  final int userId;
  late PlantInfo plantInfo;
  DateTime nextWateringDate = DateTime.now().subtract(Duration(days: 5));
  DateTime lastWatered = DateTime.now().subtract(Duration(days: 5));
  bool attacked;

  Plant({
    required this.userId,
    required this.attacked,
    required this.id,
    required this.plantInfo
  }) {
    nextWateringDate = getNextWateringDayDate(plantInfo);
  }

  factory Plant.fromJson(Map<String, dynamic> json) {
    final plantInfo = PlantInfo.fromJson({
      'name': json['name'],
      'type': json['type'],
      'wateringDays': List<String>.from(json['watering_days']),
      'location': json['location'],
    });

    // Erstelle das Plant-Objekt.
    Plant plant = Plant(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      attacked: json['attacked'] as bool,
      plantInfo: plantInfo,
    );

    // Überschreibe lastWatered und nextWateringDate mit den Werten aus der JSON-Antwort.
    plant.lastWatered = DateTime.parse(json['last_watered'] as String);
    plant.nextWateringDate = DateTime.parse(json['next_watering_date'] as String);
    return plant;
  }

  Map<String, dynamic> toJsonReduced() {
    return {
      'attacked': attacked,
      'last_watered': lastWatered.toIso8601String(),
      'next_watering_date': nextWateringDate.toIso8601String(),
      'name': plantInfo.name,
      'type': plantInfo.type,
      'watering_days': plantInfo.wateringDays,
      'location': plantInfo.location,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'attacked': attacked,
      'last_watered': lastWatered.toIso8601String(),
      'next_watering_date': nextWateringDate.toIso8601String(),
      'name': plantInfo.name,
      'type': plantInfo.type,
      'watering_days': plantInfo.wateringDays,
      'location': plantInfo.location,
    };
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
    // Mapping der Wochentage auf Ganzzahlen
    Map<String, int> dayMapping = {
      'Montag': DateTime.monday,
      'Dienstag': DateTime.tuesday,
      'Mittwoch': DateTime.wednesday,
      'Donnerstag': DateTime.thursday,
      'Freitag': DateTime.friday,
      'Samstag': DateTime.saturday,
      'Sonntag': DateTime.sunday,
    };

    // Konvertieren der Bewässerungstage in eine Liste von Ganzzahlen
    List<int> wateringDays = plantInfo.wateringDays.map((day) => dayMapping[day]!).toList();
    wateringDays.sort();

    // Aktueller Wochentag
    int today = DateTime.now().weekday;

    // Nächster geplanter Bewässerungstag
    int? nextWateringDay;
    for (int day in wateringDays) {
      if (day > today) {
        nextWateringDay = day;
        break;
      }
    }
    // Wenn kein zukünftiger Tag gefunden wurde, nehmen wir den ersten Tag der nächsten Woche
    nextWateringDay ??= wateringDays.first;

    // Berechnung des nächsten Bewässerungsdatums
    int daysUntilNextWatering = (nextWateringDay - today + 7) % 7;
    if (daysUntilNextWatering == 0) daysUntilNextWatering = 7; // Falls heute der Bewässerungstag ist, auf nächste Woche setzen
    DateTime nextWateringDate = DateTime.now().add(Duration(days: daysUntilNextWatering));

    // Anpassung des nächsten Bewässerungstags basierend auf der Bewässerungshistorie
    int daysSinceLastWatering = DateTime.now().difference(lastWatered).inDays;
    if (daysSinceLastWatering < 3) {
      // Wenn in den letzten 3 Tagen bewässert wurde, überspringen wir den nächsten geplanten Tag
      int currentIndex = wateringDays.indexOf(nextWateringDay);
      int nextIndex = (currentIndex + 1) % wateringDays.length;
      nextWateringDay = wateringDays[nextIndex];
      daysUntilNextWatering = (nextWateringDay - today + 7) % 7;
      if (daysUntilNextWatering == 0) daysUntilNextWatering = 7;
      nextWateringDate = DateTime.now().add(Duration(days: daysUntilNextWatering));
    }

    return nextWateringDate;
  }

  @override
  String toString() {
    return 'Plant{id: $id, plantInfo: $plantInfo, nextWateringDate: $nextWateringDate, lastWatered: $lastWatered, attacked: $attacked}';
  }
}
