import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ta_chegando_fixed/pages/informacoes_parada.dart';

class Marcadores {
  static Marker parada(double latitude, double longitude, String nome, String codigo) {
    return Marker(
        point: LatLng(latitude, longitude),
        builder: (context) {
          final ColorScheme cor = Theme.of(context).colorScheme;
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InformacoesParada(nome, codigo),
              ),
            ),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? cor.primary
                    : cor.tertiary,
              ),
              child: Icon(
                Icons.directions_bus,
                color: MediaQuery.of(context).platformBrightness ==
                        Brightness.light
                    ? cor.onPrimary
                    : cor.onTertiary,
              ),
            ),
          );
        });
  }

  static CircleMarker posicaoAtual(double latitude, double longitude) {
    return CircleMarker(
        point: LatLng(latitude, longitude),
        radius: 12,
        color: Colors.blue,
        borderColor: Colors.white,
        borderStrokeWidth: 3.0);
  }
}
