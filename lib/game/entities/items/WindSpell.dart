
import 'dart:math';

import 'Item.dart';

class WindSpellItem extends Item {

  WindSpellItem({
    String name = "Windzauber",
    String assetPath = "assets/images/items/WindSpell.png",
    double value = 100,
    int price = 150,
    String description = "Ein Zauber der dem Gegner Schaden hinzufügt.",
  }) : super(
    name: name,
    assetPath: assetPath,
    effect: 'Boss-Wind-Damage',
    value: value,
    price: price,
    description: description,
    randomAddition: Random().nextInt(30)+1,
  );
}
