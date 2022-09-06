import 'package:biomaapp/models/Clips.dart';
import 'package:biomaapp/models/convenios.dart';
import 'package:biomaapp/models/medicos.dart';
import 'package:biomaapp/models/pacientes.dart';
import 'package:biomaapp/models/procedimento.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Fila with ChangeNotifier {
  late Medicos medico;
  late String data;
  late String olho;
  late String horario;
  late String sequencial;
  late String status;
  late Procedimento procedimento;
  late Unidade unidade;
  late Convenios convenios;
  late Usuario indicado;
  late Usuario indicando;
  late String dataindicacao = '';
  late String horaindicacao = '';
  late String obs = '';

  Fila({
    required this.unidade,
    required this.convenios,
    required this.medico,
    required this.procedimento,
    required this.data,
    required this.olho,
    required this.horario,
    required this.sequencial,
    required this.status,
    required this.indicado,
    required this.indicando,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fila &&
          runtimeType == other.runtimeType &&
          sequencial.toString() == other.sequencial.toString();

  @override
  int get hashCode => sequencial.toString().hashCode;

  @override
  String toString() {
    return sequencial.toString();
  }
}
