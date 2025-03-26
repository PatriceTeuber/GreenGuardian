import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'GameService.dart';
import 'GameStateProvider.dart';
import 'auth_provider.dart';

class GameLifecycleHandler extends StatefulWidget {
  final Widget child;

  const GameLifecycleHandler({super.key, required this.child});

  @override
  State<GameLifecycleHandler> createState() => _GameLifecycleHandlerState();
}

class _GameLifecycleHandlerState extends State<GameLifecycleHandler> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _saveGame();
    }
  }

  void _saveGame() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final gameData = Provider.of<GameStateProvider>(context, listen: false).currentGameData;
    GameService().addOrUpdateGameData(
      userId: authProvider.userId,
      gameData: gameData.toJson(),
    );
    debugPrint("✅ Game wurde gespeichert beim Beenden.");
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
