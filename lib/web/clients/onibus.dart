import 'dart:convert';
import 'dart:io';

import 'package:ta_chegando/models/linha_de_onibus.dart';
import 'package:ta_chegando/web/client.dart';

class OnibusWebClient {
  final baseURL = Uri.parse("http://api.olhovivo.sptrans.com.br/v2.1");

  /// Token para login
  final token =
      "52708040eaca46816d1209138a574cb7cc334abcde5458c28c81e0519acece3b";

  /// Loga na aplicação.
  void logar() {
    client
        .post(Uri.parse("$baseURL/Login/Autenticar?token=$token"))
        .timeout(const Duration(seconds: 5));
  }

  /// Retorna uma lista com todas as linhas existentes de acordo com o arquivo
  /// do GTFS da API.
  Future todosOnibus() async {
    List<LinhaOnibus> linhasDeOnibus = [];
    List<String> arquivoDeTexto =
        await File("assets/linhas.txt").readAsLines(encoding: utf8);

    for (int linha = 1; linha < arquivoDeTexto.length; linha++) {
      List<String> informacoesOnibus = arquivoDeTexto[linha]
          .replaceAll("\"", '')
          .replaceAll(" - ", ",")
          .replaceAll("-", ",")
          .split(",");

      LinhaOnibus onibus = LinhaOnibus(
        letreiroEsquerda: informacoesOnibus[0],
        letreiroDireita: informacoesOnibus[1],
        terminalPrimario: informacoesOnibus[5],
        terminalSecundario: informacoesOnibus[6],
      );

      linhasDeOnibus.add(onibus);
    }

    return linhasDeOnibus;
  }
}
