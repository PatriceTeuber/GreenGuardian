
import 'dart:math';

import 'Item.dart';

class BombItem extends Item {

  BombItem({
    String name = "Bombe",
    String assetPath = "assets/images/items/defaultBomb.png",
    double value = 15,
    int price = 20,
    String description = "Eine Bombe die dem Gegner etwas Schaden hinzufügt.",
  }) : super(
    name: name,
    assetPath: assetPath,
    effect: 'Boss-Schaden',
    value: value,
    price: price,
    description: description,
    randomAddition: Random().nextInt(10)+1,
  );
}
