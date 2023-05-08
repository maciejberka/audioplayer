import 'package:audio_player/models/player_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => PlayerModel(),
    child: const APApp(),
  ));
}

class APApp extends StatelessWidget {
  const APApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Audio player Demo',
      home: HomeScreen(),
    );
  }
}
