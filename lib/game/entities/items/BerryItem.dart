import 'dart:math';
import 'Item.dart';

class BerryItem extends Item {

  BerryItem({
    String name = "Beere",
    String assetPath = "assets/images/items/Berry.png",
    double value = 10,
    int price = 20,
    String description = "Eine Beere, die bei Verzehr etwas HP wiederherstellt.",

  }) : super(
        name: name,
        assetPath: assetPath,
        effect: 'Heilt',
        value: value,
        price: price,
        description: description,
        randomAddition: Random().nextInt(15)+1
      );
}
