import 'package:flutter/material.dart';

import '../game/PlantGame.dart';
import '../game/Shop.dart';

class ShopPage extends StatelessWidget {
  final PlantGame plantGame;
  const ShopPage({super.key, required this.plantGame});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shop(plantGame: plantGame),
    );
  }
}
