class Item {
  final String name;
  final String assetPath;
  final String effect; // z. B. "Heilt" oder "Boss-Schaden"
  final double value;

  Item({
    required this.name,
    required this.assetPath,
    required this.effect,
    required this.value,
  });
}
