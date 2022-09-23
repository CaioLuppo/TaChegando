import 'package:flutter/material.dart';

import 'components/navegador.dart';

void main() {
  runApp(const TaChegando());
}

class TaChegando extends StatelessWidget {
  const TaChegando({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 255, 106),
          brightness: Brightness.dark,
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 255, 106),
          brightness: Brightness.light,
        ),
      ),
      home: const Navegador(),
    );
  }
}
