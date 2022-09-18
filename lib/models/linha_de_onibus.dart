import '../pages/onibus_page.dart';

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
      : letreiroEsquerda = json["lt"].toString(),
        letreiroDireita = json["tl"].toString(),
        terminalPrimario = json["tp"].toString(),
        terminalSecundario = json["ts"].toString(),
        cor = "" {
          for (LinhaOnibus onibus in todosOnibusCache) {
            if (letreiroEsquerda == onibus.letreiroEsquerda) cor = onibus.cor;
          }
        }
  
  

}
