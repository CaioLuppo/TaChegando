import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ta_chegando_fixed/components/marcadores.dart';
import 'package:ta_chegando_fixed/models/parada.dart';

import '../../models/linha_de_onibus.dart';
import '../client.dart';

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
            nome: informacoes[1]+informacoes[2],
            codigo: informacoes[0],
            latidude: double.parse(informacoes[3]),
            longitude: double.parse(informacoes[4]),
          ));
          break;
        case 6:
          listaParadas.add(Parada(
            nome: informacoes[1]+informacoes[2],
            codigo: informacoes[0],
            latidude: double.parse(informacoes[4]),
            longitude: double.parse(informacoes[5]),
          ));
          break;
        case 7:
          listaParadas.add(Parada(
            nome: informacoes[1]+informacoes[2],
            codigo: informacoes[0],
            latidude: double.parse(informacoes[5]),
            longitude: double.parse(informacoes[6]),
          ));
          break;
      }
    }

    for (var parada in listaParadas) {
      paradasMapa.add(Marcadores.parada(parada.latidude, parada.longitude, parada.nome, parada.codigo));
    }
  }

  static Future<List<LinhaOnibus>> tempoOnibus(String codigoParada) async {
    String authCookie = await logar();
    final resposta = await
    client.get(
      Uri.parse("$baseURL/Previsao/Parada?codigoParada=$codigoParada"),
      headers: {"Cookie": authCookie},
    ).timeout(const Duration(seconds: 5));

    final Map<String, dynamic> listaJson = jsonDecode(resposta.body);
    final List<dynamic> onibusChegando = listaJson['p']['l'];

    return onibusChegando.map((informacaoParada) => LinhaOnibus.fromJsonChegando(informacaoParada)).toList();

  }

}
