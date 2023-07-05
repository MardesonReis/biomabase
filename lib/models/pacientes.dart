import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Usuario with ChangeNotifier {
  late String id = '';
  late String cpf = '';
  late String nome = '';
  late String datanascimento = '';
  late String sexo = '';
  late String codendereco = '';
  late String nr = '';
  late String tel_whatsapp = '';
  late String celular = '';
  late String telefone = '';
  late String email = '';
  late String ocupacao = '';
  late String logradouro = '';
  late String municipio = '';
  late String bairro = '';
  late String cep = '';
  late String uf = '';
  late String tplogradouro = '';
  late String regional = '';
  late String numerocep = '';
  late String codlogradouro = '';
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
      other is Usuario && runtimeType == other.runtimeType && cpf == other.cpf;

  @override
  int get hashCode => cpf.hashCode;

  @override
  String toString() {
    return nome;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'cpf': cpf.toString(),
      'nome': nome.toString(),
      'datanascimento': datanascimento.toString(),
      'sexo': sexo.toString(),
      'codendereco': codendereco.toString(),
      'nr': nr.toString(),
      'tel_whatsapp': tel_whatsapp.toString(),
      'celular': celular.toString(),
      'telefone': telefone.toString(),
      'email': email.toString(),
      'ocupacao': ocupacao.toString(),
      'logradouro': logradouro.toString(),
      'municipio': municipio.toString(),
      'bairro': bairro.toString(),
      'cep': cep.toString(),
      'uf': uf.toString(),
      'tplogradouro': tplogradouro.toString(),
      'regional': regional.toString(),
      'numerocep': numerocep.toString(),
      'codlogradouro': codlogradouro.toString(),
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
      ..id = json['id'].toString()
      ..cpf = json['cpf'].toString()
      ..nome = json['nome'].toString()
      ..datanascimento = json['datanascimento'].toString()
      ..sexo = json['sexo'].toString()
      ..codendereco = json['codendereco'].toString()
      ..nr = json['nr'].toString()
      ..tel_whatsapp = json['tel_whatsapp'].toString()
      ..celular = json['celular'].toString()
      ..telefone = json['telefone'].toString()
      ..email = json['email'].toString()
      ..ocupacao = json['ocupacao'].toString()
      ..logradouro = json['logradouro'].toString()
      ..municipio = json['municipio'].toString()
      ..bairro = json['bairro'].toString()
      ..cep = json['cep'].toString()
      ..uf = json['uf'].toString()
      ..tplogradouro = json['tplogradouro'].toString()
      ..regional = json['regional'].toString()
      ..numerocep = json['numerocep'].toString()
      ..codlogradouro = json['codlogradouro'].toString()
      ..primeiroatendimento = json['primeiroatendimento'].toString()
      ..primeiroatendimentoemanos = json['primeiroatendimentoemanos'].toString()
      ..datanascimentopaciente = json['datanascimentopaciente'].toString()
      ..idade = json['idade'].toString()
      ..ultimoatendimento = json['ultimoatendimento'].toString()
      ..ultimoatendimentoemanos = json['ultimoatendimentoemanos'].toString();
  }
}
