import 'package:flutter/material.dart';
import 'package:ta_chegando/web/clients/onibus_client.dart';

import 'components/navegador.dart';

void main() {
  runApp(const TaChegando());
  OnibusWebClient().todosOnibus();
}

class TaChegando extends StatelessWidget {
  const TaChegando({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
