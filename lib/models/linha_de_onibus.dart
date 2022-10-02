import '../pages/onibus_page.dart';

class LinhaOnibus {
  String letreiroEsquerda = "";
  String letreiroDireita = "";
  String letreiroCompleto = "";
  String terminalPrimario = "";
  String terminalSecundario;
  String cor = "";
  String horaChegada = "";

  LinhaOnibus(
      {this.letreiroCompleto = "",
      this.letreiroEsquerda = "",
      this.letreiroDireita = "",
      this.terminalPrimario = "",
      required this.terminalSecundario,
      this.cor = "0xFFFFFF",
      this.horaChegada = "00:00"});

  /// Cria a classe a partir dos dados que foram informados pela API
  LinhaOnibus.fromJson(Map<String, dynamic> json)
      : letreiroEsquerda = json["lt"].toString(),
        letreiroDireita = json["tl"].toString(),
        terminalPrimario = json["tp"].toString(),
        terminalSecundario = json["ts"].toString(),
        cor = "" {
    for (LinhaOnibus onibus in todosOnibusCache) {
      if (letreiroEsquerda == onibus.letreiroEsquerda) cor = onibus.cor;
    }
  }

  LinhaOnibus.fromJsonChegando(Map<String, dynamic> json)
      : letreiroCompleto = json["c"].toString(),
        terminalSecundario = json["lt1"].toString(),
        cor = "",
        horaChegada = json["vs"][0]["t"] {
    for (LinhaOnibus onibus in todosOnibusCache) {
      if (letreiroCompleto == "${onibus.letreiroEsquerda}-${onibus.letreiroDireita}") cor = onibus.cor;
    }
  }
}
