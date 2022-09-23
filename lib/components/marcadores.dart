import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Marcadores {

  static Marker parada(double latitude, double longitude) {
    return Marker(
        point: LatLng(latitude, longitude),
        builder: (context) {
          final ColorScheme cor = Theme.of(context).colorScheme;
          return Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cor.primary,
            ),
            child: Icon(
              Icons.directions_bus,
              color: cor.onPrimary,
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
      borderStrokeWidth: 3.0
    );
  }
}
