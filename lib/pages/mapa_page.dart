import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ta_chegando_fixed/components/marcadores.dart';
import 'package:ta_chegando_fixed/web/clients/paradas_client.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  bool statusLocalizacao = false;
  final ParadasWebClient _web = ParadasWebClient();
  Map<String, double> localizacaoAtual = {
    "lat": -23.5489,
    "lng": -46.6388,
  };

  @override
  void initState() {
    Geolocator.requestPermission().then((value) {
      if (value == LocationPermission.denied ||
          value == LocationPermission.deniedForever ||
          value == LocationPermission.unableToDetermine) {
        statusLocalizacao = false;
      } else {
        setState(() {
          statusLocalizacao = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tema = MediaQuery.of(context).platformBrightness;
    MapController controladorMapa = MapController();

    _web.todasParadas();
    // Atualiza a posição do usuário.
    if (statusLocalizacao) {
      Geolocator.getPositionStream().listen(
        (Position position) {
          setState(() {
            localizacaoAtual['lat'] = position.latitude;
            localizacaoAtual['lng'] = position.longitude;
          });
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (statusLocalizacao) {
            controladorMapa.move(
                LatLng(localizacaoAtual['lat']!, localizacaoAtual['lng']!), 17);
          }
        },
        child: const Icon(Icons.my_location),
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: controladorMapa,
                options: MapOptions(
                    keepAlive: false,
                    onMapReady: () {
                      statusLocalizacao == true ? _pegarLocalizacao() : null;
                      Timer(
                        const Duration(seconds: 1),
                        () => controladorMapa.move(
                          LatLng(
                            localizacaoAtual['lat']!,
                            localizacaoAtual['lng']!,
                          ),
                          16,
                        ),
                      );
                    },
                    interactiveFlags: InteractiveFlag.doubleTapZoom |
                        InteractiveFlag.pinchZoom |
                        InteractiveFlag.pinchMove |
                        InteractiveFlag.drag,
                    maxZoom: 18.0,
                    minZoom: 16.0,
                    center: LatLng(
                        localizacaoAtual['lat']!, localizacaoAtual['lng']!),
                    zoom: 17),
                children: [
                  TileLayer(
                    maxNativeZoom: 16,
                    retinaMode: true,
                    // urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",

                    urlTemplate: tema == Brightness.light
                        ? "https://api.mapbox.com/styles/v1/caioluppo/cl8ercndg000f15s32aorx8v3/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2Fpb2x1cHBvIiwiYSI6ImNsOGRmeG55bjA0OXgzdXA0dTlvcWhqb2kifQ.C5M2i9ZwuzD-qZzPfVDAlA"
                        : "https://api.mapbox.com/styles/v1/caioluppo/cl8er7xxd002514mxxfvnsa7u/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2Fpb2x1cHBvIiwiYSI6ImNsOGRmeG55bjA0OXgzdXA0dTlvcWhqb2kifQ.C5M2i9ZwuzD-qZzPfVDAlA",
                    additionalOptions: const {
                      'accessToken':
                          'pk.eyJ1IjoiY2Fpb2x1cHBvIiwiYSI6ImNsOGRmeG55bjA0OXgzdXA0dTlvcWhqb2kifQ.C5M2i9ZwuzD-qZzPfVDAlA',
                      'id': 'mapbox.mapbox-streets-v8'
                    },
                  ),
                  MarkerLayer(
                    markers: ParadasWebClient.paradasMapa,
                  ),
                  if (statusLocalizacao)
                    CircleLayer(
                      circles: [
                        Marcadores.posicaoAtual(
                          localizacaoAtual['lat']!,
                          localizacaoAtual['lng']!,
                        )
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _pegarLocalizacao() async {
    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    localizacaoAtual['lat'] = posicao.latitude;
    localizacaoAtual['lng'] = posicao.longitude;
  }
}
