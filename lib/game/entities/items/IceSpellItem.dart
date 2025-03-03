
import 'dart:math';

import 'Item.dart';

class IceSpellItem extends Item {

  IceSpellItem({
    String name = "Eiszauber",
    String assetPath = "assets/images/items/IceSpell.png",
    double value = 100,
    int price = 150,
    String description = "Ein Zauber der dem Gegner Schaden hinzufügt.",
  }) : super(
    name: name,
    assetPath: assetPath,
    effect: 'Boss-Ice-Damage',
    value: value,
    price: price,
    description: description,
    randomAddition: Random().nextInt(30)+1,
  );
}
