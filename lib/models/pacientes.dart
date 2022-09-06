import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Usuario with ChangeNotifier {
  late String pacientes_id = '';
  late String pacientes_cpf = '';
  late String pacientes_nomepaciente = '';
  late String pacientes_datanascimento = '';
  late String pacientes_sexo = '';
  late String pacientes_codendereco = '';
  late String pacientes_nr = '';
  late String pacientes_tel_whatsapp = '';
  late String pacientes_celular = '';
  late String pacientes_telefone = '';
  late String pacientes_email = '';
  late String pacientes_ocupacao = '';
  late String tabcep_logradouro = '';
  late String tabcep_municipio = '';
  late String tabcep_bairro = '';
  late String tabcep_cep = '';
  late String tabcep_uf = '';
  late String tabcep_tplogradouro = '';
  late String tabcep_regional = '';
  late String tabcep_numerocep = '';
  late String tabcep_codlogradouro = '';
  late String primeiroatendimento = '';
  late String primeiroatendimentoemanos = '';
  late String datanascimentopaciente = '';
  late String idade = '';
  late String ultimoatendimento = '';
  late String ultimoatendimentoemanos = '';

  Usuario();
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usuario &&
          runtimeType == other.runtimeType &&
          pacientes_nomepaciente == other.pacientes_nomepaciente;

  @override
  int get hashCode => pacientes_nomepaciente.hashCode;

  @override
  String toString() {
    return pacientes_nomepaciente;
  }
}
