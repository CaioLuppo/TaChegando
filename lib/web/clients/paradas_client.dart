import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ta_chegando_fixed/components/marcadores.dart';
import 'package:ta_chegando_fixed/models/parada.dart';

class ParadasWebClient {
  static List<Marker> paradasMapa = [];

  /// Lista todas as paradas.
  void todasParadas() async {
    List<Parada> listaParadas = [];
    List<String> linhasDoArquivo = await rootBundle
        .loadString("assets/paradas.txt")
        .then((value) => value.replaceAll("\"", "").split("\n"));

    for (String linha in linhasDoArquivo) {
      List<dynamic> informacoes = linha.split(",");

      switch (informacoes.length) {
        case 5:
          listaParadas.add(Parada(
            nome: informacoes[1],
            codigo: int.parse(informacoes[0]),
            latidude: double.parse(informacoes[3]),
            longitude: double.parse(informacoes[4]),
          ));
          break;
        case 6:
          listaParadas.add(Parada(
            nome: informacoes[1],
            codigo: int.parse(informacoes[0]),
            latidude: double.parse(informacoes[4]),
            longitude: double.parse(informacoes[5]),
          ));
          break;
        case 7:
          listaParadas.add(Parada(
            nome: informacoes[1],
            codigo: int.parse(informacoes[0]),
            latidude: double.parse(informacoes[5]),
            longitude: double.parse(informacoes[6]),
          ));
          break;
      }
    }

    for (var parada in listaParadas) {
      paradasMapa.add(Marcadores.parada(parada.latidude, parada.longitude));
    }
  }
}
