class LinhaOnibus {
  String letreiroEsquerda;
  String letreiroDireita;
  String terminalPrimario;
  String terminalSecundario;
  String cor;

  LinhaOnibus(
      {required this.letreiroEsquerda,
      required this.letreiroDireita,
      required this.terminalPrimario,
      required this.terminalSecundario,
      required this.cor});

  /// Cria a classe a partir dos dados que foram informados pela API
  LinhaOnibus.fromJson(Map<String, dynamic> json)
      : letreiroEsquerda = json["lt"],
        letreiroDireita = json["tl"],
        terminalPrimario = json["tp"],
        terminalSecundario = json["ts"],
        cor = '';
}
