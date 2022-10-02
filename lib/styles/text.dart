import 'package:flutter/material.dart';

class TituloBranco extends TextStyle {
  final double tamanho;
  const TituloBranco({this.tamanho = 24})
      : super(
          fontSize: tamanho,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );
}

class TituloPreto extends TextStyle {
  final double tamanho;
  final BuildContext context;

  TituloPreto(this.context, {this.tamanho = 24})
      : super(
          fontSize: tamanho,
          fontWeight: FontWeight.bold,
          color: MediaQuery.of(context).platformBrightness != Brightness.dark ? Colors.black : Colors.white,
        );
}
