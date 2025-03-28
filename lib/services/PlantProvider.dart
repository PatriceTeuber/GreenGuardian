import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantProvider with ChangeNotifier {
  List<Plant> _plants = [];

  List<Plant> get plants => _plants;

  void setPlants(List<Plant> plants) {
    _plants = plants;
    notifyListeners();
  }

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }

  bool waterPlant(Plant plant) {
    if (plant.lastWatered.day != DateTime.now().day) {
      // Aktualisiere lastWatered
      plant.lastWatered = DateTime.now();
      // Berechne nextWateringDate neu
      plant.nextWateringDate = plant.getNextWateringDayDate(plant.plantInfo);
      // Informiere alle Zuhörer, dass sich der Zustand geändert hat
      print(plant.toString());
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
