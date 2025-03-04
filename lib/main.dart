import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:green_guardian/game/PlantGame.dart';
import 'package:green_guardian/pages/home_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
