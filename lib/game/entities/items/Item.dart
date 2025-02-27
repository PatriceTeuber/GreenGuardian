class Item {
  final String name;
  final String assetPath;
  final String effect; // z. B. "Heilt" oder "Boss-Schaden"
  final double value;
  final int price;
  final String description;
  final int randomAddition;

  Item({
    required this.randomAddition,
    required this.description,
    required this.price,
    required this.name,
    required this.assetPath,
    required this.effect,
    required this.value,
  });
}
