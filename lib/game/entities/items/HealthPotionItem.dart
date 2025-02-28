import 'dart:math';
import 'Item.dart';

class HealthPotionItem extends Item {

  HealthPotionItem({
    super.name = "Heiltrank",
    super.assetPath = "assets/images/items/HealthPotion.png",
    super.value = 30,
    super.price = 85,
    super.description = "Ein Trank, der bei Verzehr eine größere Menge HP wiederherstellt.",

  }) : super(
      effect: 'Heilt',
      randomAddition: Random().nextInt(20)+1
  );
}
