import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Clips with ChangeNotifier {
  final String titulo;
  final String subtitulo;
  final String keyId;

  Clips({this.titulo = '', this.subtitulo = '', this.keyId = ''});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Clips &&
          runtimeType == other.runtimeType &&
          titulo == other.titulo;

  @override
  int get hashCode => titulo.hashCode;

  @override
  String toString() {
    return titulo;
  }
}
