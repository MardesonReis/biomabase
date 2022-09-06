import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Agendamentos with ChangeNotifier {
  String data_movimento = '';
  String cod_paciente = '';
  String cod_procedimento = '';
  String des_procedimento = '';
  String des_uni_procedimentos = '';
  String status = '';
  String olho = '';
  String dataatendimento = '';
  String cod_profissional = '';
  String des_profissional = '';
  String cod_unidade = '';
  String des_unidade = '';
  String cod_especialidade = '';
  String des_especialidade = '';
  String cod_convenio = '';
  String des_convenio = '';
  String cod_atendimento = '';
  String cod_parceiro = '';
  String cpf_paciente = '';
  String cpf_parceiro = '';
  String quantidade = '';
  String valor = '';
  String hora_marcacao = '';

  Agendamentos();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Agendamentos &&
          runtimeType == other.runtimeType &&
          cod_atendimento == other.cod_atendimento;

  @override
  int get hashCode => cod_atendimento.hashCode;

  @override
  String toString() {
    return cod_atendimento;
  }
}
