import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class MinhaSaude with ChangeNotifier {
  late String id;
  late String grupo;
  late String subgrupo;
  late String tipo;
  late String descricao;
  late String medida;
  late String franquencia;
  late String range_i;
  late String range_f;
  late String valor = '';

  MinhaSaude({
    required this.id,
    required this.grupo,
    required this.subgrupo,
    required this.descricao,
    required this.medida,
    required this.franquencia,
    required this.range_i,
    required this.range_f,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinhaSaude &&
          runtimeType == other.runtimeType &&
          id.toString() == other.id.toString();

  @override
  int get hashCode => id.toString().hashCode;

  @override
  String toString() {
    return grupo.toString() + '-' + subgrupo.toString();
  }
}
