
import 'dart:math';

import 'Item.dart';

class IceSpellItem extends Item {

  IceSpellItem({
    String name = "Eiszauber",
    String assetPath = "assets/images/items/IceSpell.png",
    double value = 15,
    int price = 20,
    String description = "Ein Zauber der dem Gegner Schaden hinzufügt.",
  }) : super(
    name: name,
    assetPath: assetPath,
    effect: 'Boss-Ice-Damage',
    value: value,
    price: price,
    description: description,
    randomAddition: Random().nextInt(10)+1,
  );
}
