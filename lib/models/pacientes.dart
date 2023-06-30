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
          pacientes_cpf == other.pacientes_cpf;

  @override
  int get hashCode => pacientes_cpf.hashCode;

  @override
  String toString() {
    return pacientes_nomepaciente;
  }

  Map<String, dynamic> toJson() {
    return {
      'pacientes_id': pacientes_id.toString(),
      'pacientes_cpf': pacientes_cpf.toString(),
      'pacientes_nomepaciente': pacientes_nomepaciente.toString(),
      'pacientes_datanascimento': pacientes_datanascimento.toString(),
      'pacientes_sexo': pacientes_sexo.toString(),
      'pacientes_codendereco': pacientes_codendereco.toString(),
      'pacientes_nr': pacientes_nr.toString(),
      'pacientes_tel_whatsapp': pacientes_tel_whatsapp.toString(),
      'pacientes_celular': pacientes_celular.toString(),
      'pacientes_telefone': pacientes_telefone.toString(),
      'pacientes_email': pacientes_email.toString(),
      'pacientes_ocupacao': pacientes_ocupacao.toString(),
      'tabcep_logradouro': tabcep_logradouro.toString(),
      'tabcep_municipio': tabcep_municipio.toString(),
      'tabcep_bairro': tabcep_bairro.toString(),
      'tabcep_cep': tabcep_cep.toString(),
      'tabcep_uf': tabcep_uf.toString(),
      'tabcep_tplogradouro': tabcep_tplogradouro.toString(),
      'tabcep_regional': tabcep_regional.toString(),
      'tabcep_numerocep': tabcep_numerocep.toString(),
      'tabcep_codlogradouro': tabcep_codlogradouro.toString(),
      'primeiroatendimento': primeiroatendimento.toString(),
      'primeiroatendimentoemanos': primeiroatendimentoemanos.toString(),
      'datanascimentopaciente': datanascimentopaciente.toString(),
      'idade': idade.toString(),
      'ultimoatendimento': ultimoatendimento.toString(),
      'ultimoatendimentoemanos': ultimoatendimentoemanos.toString(),
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario()
      ..pacientes_id = json['pacientes_id']
      ..pacientes_cpf = json['pacientes_cpf']
      ..pacientes_nomepaciente = json['pacientes_nomepaciente']
      ..pacientes_datanascimento = json['pacientes_datanascimento']
      ..pacientes_sexo = json['pacientes_sexo']
      ..pacientes_codendereco = json['pacientes_codendereco']
      ..pacientes_nr = json['pacientes_nr']
      ..pacientes_tel_whatsapp = json['pacientes_tel_whatsapp']
      ..pacientes_celular = json['pacientes_celular']
      ..pacientes_telefone = json['pacientes_telefone']
      ..pacientes_email = json['pacientes_email']
      ..pacientes_ocupacao = json['pacientes_ocupacao']
      ..tabcep_logradouro = json['tabcep_logradouro']
      ..tabcep_municipio = json['tabcep_municipio']
      ..tabcep_bairro = json['tabcep_bairro']
      ..tabcep_cep = json['tabcep_cep']
      ..tabcep_uf = json['tabcep_uf']
      ..tabcep_tplogradouro = json['tabcep_tplogradouro']
      ..tabcep_regional = json['tabcep_regional']
      ..tabcep_numerocep = json['tabcep_numerocep']
      ..tabcep_codlogradouro = json['tabcep_codlogradouro']
      ..primeiroatendimento = json['primeiroatendimento']
      ..primeiroatendimentoemanos = json['primeiroatendimentoemanos']
      ..datanascimentopaciente = json['datanascimentopaciente']
      ..idade = json['idade']
      ..ultimoatendimento = json['ultimoatendimento']
      ..ultimoatendimentoemanos = json['ultimoatendimentoemanos'];
  }
}
