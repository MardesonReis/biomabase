import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class AgendaMedico with ChangeNotifier {
  final String medico;
  final String data;
  final String turno;
  final String mesano;
  final String observacao;
  final String horario;
  final String sequencial;
  final String status;
  final String tratamento;
  final String reservado;
  final String usuario;
  final String unidade;
  final String especialidade;
  final String motivodesmarcar;
  final String tipodeplantao;
  final String consultorio;
  final String codconsultorio;
  final String avulso;

  AgendaMedico({
    required this.medico,
    required this.data,
    required this.turno,
    required this.mesano,
    required this.observacao,
    required this.horario,
    required this.sequencial,
    required this.status,
    required this.tratamento,
    required this.reservado,
    required this.usuario,
    required this.unidade,
    required this.especialidade,
    required this.motivodesmarcar,
    required this.tipodeplantao,
    required this.consultorio,
    required this.codconsultorio,
    required this.avulso,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgendaMedico &&
          runtimeType == other.runtimeType &&
          data.toString() == other.data.toString();

  @override
  int get hashCode => data.toString().hashCode;

  @override
  String toString() {
    return data.toString();
  }
}
