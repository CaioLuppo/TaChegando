import 'package:flutter/material.dart';
import 'package:ta_chegando_fixed/web/clients/paradas_client.dart';

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
          primary: const Color.fromARGB(255, 30, 30, 30),
          secondary: const Color.fromARGB(255, 255, 255, 255),
          onPrimary: const Color.fromARGB(255, 255, 255, 255)
        ),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ButtonStyle(
        //     backgroundColor: MaterialStateProperty.all(Colors.black54),
        //     foregroundColor: MaterialStateProperty.all(Colors.white),
        //     shadowColor: MaterialStateProperty.all(Colors.black54),
        //   ),
        // ),
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
