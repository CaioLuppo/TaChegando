class LinhaOnibus {
  String letreiroEsquerda;
  String letreiroDireita;
  String terminalPrimario;
  String terminalSecundario;

  LinhaOnibus({
    required this.letreiroEsquerda,
    required this.letreiroDireita,
    required this.terminalPrimario,
    required this.terminalSecundario,
  });

  /// Cria a classe a partir dos dados que foram informados pela API
  LinhaOnibus.fromJson(Map<String, dynamic> json)
      : letreiroEsquerda = json["lt"],
        letreiroDireita = json["tl"],
        terminalPrimario = json["tp"],
        terminalSecundario = json["ts"];
}
