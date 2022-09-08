import 'package:flutter/material.dart';
import 'package:ta_chegando/models/linha_de_onibus.dart';
import 'package:ta_chegando/styles/text.dart';
import 'package:ta_chegando/web/clients/onibus.dart';

class OnibusPage extends StatelessWidget {
  OnibusPage({super.key});

  final OnibusWebClient _web = OnibusWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onSubmitted: (value) {}, // TODO: Buscar
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<LinhaOnibus>>(
                future: Future.delayed(
                  const Duration(seconds: 2),
                ).then(
                  (value) => _web.todosOnibus(),
                ),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      break;
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.active:
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        final todosOnibus = snapshot.data ?? [];
                        if (todosOnibus.isNotEmpty) {
                          return Flex(
                            direction: Axis.vertical,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: todosOnibus.length,
                                itemBuilder: (context, index) {
                                  final onibus = todosOnibus[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 0, 4),
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
                            ],
                          );
                        }
                      }
                  }
                  return const Text("Erro ao carregar linhas");
                },
              ),
            ),
          ),
        ),
      ),
    );
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
            height: 40,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Icon(Icons.directions_bus),
                  ),
                  Text(
                    "${onibus.letreiroEsquerda}/${onibus.letreiroDireita} - ${onibus.terminalPrimario} → ${onibus.terminalSecundario}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ));
}
