import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:ta_chegando_fixed/pages/onibus_page.dart';

import '/models/linha_de_onibus.dart';
import '/web/client.dart';

class OnibusWebClient {

  /// Retorna uma lista com todas as linhas existentes de acordo com o arquivo
  /// do GTFS da API.
  Future<void> todosOnibus() async {
    List<LinhaOnibus> linhasDeOnibus = [];
    List<String> arquivoDeTexto = await rootBundle
        .loadString("assets/linhas.txt")
        .then((value) => value.split("\n"));

    for (int linha = 1; linha < arquivoDeTexto.length; linha++) {
      List<String> informacoesOnibus = arquivoDeTexto[linha]
          .replaceAll("\"", '')
          .replaceAll(" - ", ",")
          .replaceAll("-", ",")
          .replaceAll("|", "-")
          .split(",");

      LinhaOnibus onibus = LinhaOnibus(
        letreiroEsquerda: informacoesOnibus[0],
        letreiroDireita: informacoesOnibus[1],
        terminalPrimario: informacoesOnibus[5],
        terminalSecundario: informacoesOnibus[6],
        cor: informacoesOnibus[8],
      );

      linhasDeOnibus.add(onibus);
    }

    todosOnibusCache = linhasDeOnibus;
  }

  /// Retorna uma lista com os ônibus procurados pelo usuário.
  Future<List<LinhaOnibus>> buscaOnibus(String termoBusca) async {
    // Loga e faz a requisição pra API.
    String authCookie = await logar();
    final Response respostaJson = await client.get(
      Uri.parse(
          "$baseURL/Linha/BuscarLinhaSentido?termosBusca=$termoBusca&sentido=1"),
      headers: {'Cookie': authCookie},
    ).timeout(const Duration(seconds: 5));

    /// Lista dos Json presentes no body da requisição.
    final List<dynamic> listaJson = jsonDecode(respostaJson.body);

    return listaJson
        .map((onibusJson) => LinhaOnibus.fromJson(onibusJson))
        .toList();
  }
}
