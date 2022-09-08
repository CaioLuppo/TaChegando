import 'package:flutter/material.dart';

class TituloBranco extends TextStyle {
  double tamanho;
  TituloBranco({this.tamanho = 24})
      : super(
          fontSize: tamanho,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );
}
