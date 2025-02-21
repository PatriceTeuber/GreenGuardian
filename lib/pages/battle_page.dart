import 'package:flutter/material.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampf'),
      ),
      body: const Center(
        child: Text('Kampf Seite'),
      ),
    );
  }
}
