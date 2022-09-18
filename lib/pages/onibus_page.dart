import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import '../models/linha_de_onibus.dart';
import '../styles/text.dart';
import '../web/clients/onibus_client.dart';

class OnibusPage extends StatefulWidget {
  const OnibusPage({super.key});

  @override
  State<OnibusPage> createState() => _OnibusPageState();
}

/// Variável usada para evitar buscas desnecessárias no arquivo de ônibus.
List<LinhaOnibus> todosOnibusCache = [];

class _OnibusPageState extends State<OnibusPage> {
  final OnibusWebClient _web = OnibusWebClient();

  bool mostrarTudo = false;

  bool buscou = false;
  String termoBusca = '';

  @override
  Widget build(BuildContext context) {
    _web.todosOnibus();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Pesquisar ônibus:",
                  style: TituloBranco(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 16),
                child: TextField(
                  cursorColor: Theme.of(context).backgroundColor,
                  cursorRadius: const Radius.circular(20),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                    hintText: "Ex: Vila Mariana ou 917H",
                    hintStyle: TextStyle(fontSize: 16),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (texto) {
                    setState(() {
                      if (texto.isNotEmpty) {
                        termoBusca = removeDiacritics(texto.toLowerCase());
                        buscou = true;
                      } else {
                        mostrarTudo = false;
                        buscou = false;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<LinhaOnibus>>(
        future: Future.delayed(
          const Duration(seconds: 2),
        ).then(
          (value) async {
            return buscou ? await buscaOnibusInteligente() : todosOnibusCache;
          },
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text("Carregando"),
                    )
                  ],
                ),
              );
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final todosOnibus = snapshot.data ?? [];
                if (todosOnibus.isNotEmpty) {
                  return Column(
                    children: [
                      Flexible(
                        child: Scrollbar(
                          radius: const Radius.circular(20),
                          thickness: 10,
                          trackVisibility: true,
                          interactive: true,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            addAutomaticKeepAlives: true,
                            shrinkWrap: true,
                            itemCount:
                                mostrarTudo || buscou ? todosOnibus.length : 4,
                            itemBuilder: (context, index) {
                              final onibus = todosOnibus[index];
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 0),
                                      )
                                    ],
                                  ),
                                  child: _CartaoOnibus(onibus),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (!mostrarTudo && !buscou)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mostrarTudo = true;
                              });
                            },
                            child: const Text("Mostrar tudo"),
                          ),
                        )
                    ],
                  );
                } else {
                  return const Center(
                    child: Text("Nenhum ônibus encontrado."),
                  );
                }
              }
          }
          return const Center(child: Text("Erro desconhecido"));
        },
      ),
    );
  }

  /// Utiliza o método de buscaOnibus porém filtrando a entrada do usuário
  /// e adaptrando para o sistema da API.
  Future<List<LinhaOnibus>> buscaOnibusInteligente() async {
    var abreviacoes = {
      // Abreviações que a API utiliza.
      "terminal": "term",
      "vila": "vl",
      "escola": "esc",
      "jardim": "jd",
      "parque": "pq",
      "lago": "lgo",
      "hospital": "hosp"
    };
    List<LinhaOnibus> respostaOnibus = [];

    String termoBuscaAdaptado = termoBusca;
    abreviacoes.forEach((key, value) {
      termoBuscaAdaptado = termoBuscaAdaptado.replaceAll(key, value);
    });
    respostaOnibus = await _web.buscaOnibus(termoBuscaAdaptado);

    String termoBuscaAdaptado2 = termoBusca;
    abreviacoes.forEach((key, value) {
      termoBuscaAdaptado = termoBuscaAdaptado.replaceAll(value, key);
    });
    respostaOnibus.addAll(await _web.buscaOnibus(termoBuscaAdaptado2));

    return respostaOnibus;
  }
}

class _CartaoOnibus extends Container {
  final LinhaOnibus onibus;

  _CartaoOnibus(this.onibus)
      : super(
            padding: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(int.parse('0xFF${onibus.cor}')),
            ),
            height: 90,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Icon(Icons.directions_bus),
                      ),
                      Text(
                        "${onibus.letreiroEsquerda}/${onibus.letreiroDireita}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Icon(Icons.arrow_forward),
                      ),
                      Text(onibus.terminalPrimario)
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Icon(Icons.arrow_back),
                      ),
                      Text(onibus.terminalSecundario)
                    ],
                  ),
                ],
              ),
            ));
}
