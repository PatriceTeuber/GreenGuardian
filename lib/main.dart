import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:green_guardian/pages/login.dart';
import 'package:green_guardian/services/GameLifecycleHandler.dart';
import 'package:green_guardian/services/GameStateProvider.dart';
import 'package:green_guardian/services/PlantProvider.dart';
import 'package:green_guardian/services/auth_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PlantProvider()),
      ChangeNotifierProvider(create: (_) => GameStateProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: GameLifecycleHandler(child: MyApp()),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Guardian',
      theme: ThemeData(
        primarySwatch: Colors.green,
        // Optional: Für feinere Anpassungen kannst du auch das colorScheme anpassen:
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(
          secondary: Colors.greenAccent, // z.B. für Buttons oder Akzente
        ),
        // Hier kannst du auch globale TextStyles, ButtonThemes etc. definieren.
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
