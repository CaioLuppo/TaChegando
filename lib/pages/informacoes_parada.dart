import 'package:flutter/material.dart';
import 'package:ta_chegando_fixed/components/loading.dart';
import 'package:intl/intl.dart';
import 'package:ta_chegando_fixed/styles/text.dart';
import 'package:ta_chegando_fixed/web/clients/paradas_client.dart';

import '../models/linha_de_onibus.dart';

class InformacoesParada extends StatefulWidget {
  final String nomeParada;
  final String codigo;

  const InformacoesParada(this.nomeParada, this.codigo, {super.key});

  @override
  State<InformacoesParada> createState() => _InformacoesParadaState();
}

class _InformacoesParadaState extends State<InformacoesParada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Icon(
                Icons.share_location_rounded,
                size: 32,
              ),
            ),
            Flexible(
              child: Text(
                widget.nomeParada,
                style: const TituloBranco(tamanho: 20),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  "Tá chegando",
                  style: TituloPreto(context, tamanho: 32),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => setState(() {}),
                  child: Icon(
                    Icons.refresh_rounded,
                    size: 32,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                )
              ],
            ),
          ),
          Flexible(
            child: FutureBuilder<List<LinhaOnibus>>(
              future: ParadasWebClient.tempoOnibus(widget.codigo),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return const Loading();
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      List onibusList = snapshot.data ?? [];
                      return ListView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        shrinkWrap: true,
                        itemCount: onibusList.length,
                        itemBuilder: (context, idx) {
                          LinhaOnibus onibus = onibusList[idx];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _CartaoOnibus(
                              onibus,
                              context,
                              _calcularHora(onibus),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("Nenhum ônibus encontrado."),
                      );
                    }
                }
                return const Center(child: Text("Erro desconhecido"));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Vai chegar",
              style: TituloPreto(context, tamanho: 32),
            ),
          ),
        ],
      ),
    );
  }

  String _calcularHora(LinhaOnibus onibus) {
    int horaOnibus = int.parse(onibus.horaChegada.substring(0, 1));
    int minutosOnibus = int.parse(onibus.horaChegada.substring(3, 4));

    String tempoAtual = DateFormat('kk:mm').format(DateTime.now());
    int horaAtual = int.parse(tempoAtual.substring(0, 1));
    int minutoAtual = int.parse(tempoAtual.substring(3, 4));

    String minutoReturn = "";
    String horaReturn = "";

    if (minutosOnibus < minutoAtual) {
      horaOnibus--;
      minutosOnibus += 60;
      minutoReturn = (minutosOnibus - minutoAtual).toString();
    } else {
      minutoReturn = (minutosOnibus - minutoAtual).toString();
    }

    horaReturn = (horaOnibus - horaAtual).toString();

    if (horaReturn == "0") {
      if (minutoReturn == "0") {
        return "Chegando! ";
      } else {
        return "$minutoReturn min ";
      }
    } else {
      return "$horaReturn h $minutoReturn min ";
    }
  }
}

class _CartaoOnibus extends Container {
  final LinhaOnibus onibus;
  final BuildContext context;
  final String tempoAteChegar;

  _CartaoOnibus(this.onibus, this.context, this.tempoAteChegar)
      : super(
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(15, 0, 0, 0),
                spreadRadius: 0.2,
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(10.0),
            color: Color(int.parse('0xFF${onibus.cor}')),
          ),
          height: 40,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0)),
              color: Theme.of(context).colorScheme.surface,
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
                      onibus.letreiroCompleto,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        onibus.terminalSecundario,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      tempoAteChegar,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const RotatedBox(
                      quarterTurns: 45,
                      child: Icon(
                        Icons.wifi_rounded,
                        size: 20,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
}
