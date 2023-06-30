import 'dart:convert';

import 'package:biomaapp/models/especialidade.dart';
import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Medicos with ChangeNotifier {
  String cod_profissional;
  String des_profissional;
  String celular;
  String crm;
  String data_nascimento;
  String cpf;
  String nomecompleto;
  String ativo;
  String email;
  String subespecialidade;
  String idademin;
  String idademax;
  String pacientesAtendidos;
  String totalDeAtendidos;
  Especialidade especialidade;

  Medicos({
    this.cod_profissional = '',
    this.des_profissional = '',
    this.celular = '',
    this.crm = '',
    this.data_nascimento = '',
    this.cpf = '',
    this.nomecompleto = '',
    this.ativo = '',
    this.email = '',
    this.subespecialidade = '',
    this.idademin = '',
    this.idademax = '',
    this.pacientesAtendidos = '',
    this.totalDeAtendidos = '',
    required this.especialidade,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medicos &&
          runtimeType == other.runtimeType &&
          des_profissional == other.des_profissional;

  @override
  int get hashCode => des_profissional.hashCode;

  @override
  String toString() {
    return des_profissional;
  }

  static Future<Medicos> toId(String medico) async {
    String link =
        '${Constants.MEDICOS_BASE_URL}/' + medico + '/' + Constants.AUT_BASE;
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      final List data = jsonResponse['dados'];
      final medicoData = data.first;
      final especialidadeCodigo = medicoData['cod_especialidade'];
      print(especialidadeCodigo);
      final especialidade = await Especialidade.fromId(especialidadeCodigo);

      return Medicos(
        cod_profissional: medicoData['cod_profissional'] ?? '',
        des_profissional: medicoData['des_profissional'] ?? '',
        celular: medicoData['celular'] ?? '',
        crm: medicoData['crm'] ?? '',
        data_nascimento: medicoData['data_nascimento'] ?? '',
        cpf: medicoData['cpf'] ?? '',
        nomecompleto: medicoData['nomecompleto'] ?? '',
        ativo: medicoData['ativo'] ?? '',
        email: medicoData['email'] ?? '',
        subespecialidade: medicoData['subespecialidade'] ?? '',
        idademin: medicoData['idademin'] ?? '',
        idademax: medicoData['idademax'] ?? '',
        pacientesAtendidos: medicoData['pacientesAtendidos'] ?? '',
        totalDeAtendidos: medicoData['totalDeAtendidos'] ?? '',
        especialidade: especialidade,
      );
    } else {
      throw Exception('Falha ao obter os dados do médico.');
    }
  }

  static Future<Medicos> tocpf(String cpf) async {
    String link =
        Constants.MEDICOS_BASE_URL + '/0/0/' + cpf + Constants.AUT_BASE;
    final response = await http.get(
      Uri.parse(link),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final medicoData = jsonResponse['data'];

      final especialidadeCodigo = medicoData['cod_especialidade'];

      final especialidade = await Especialidade.fromId(especialidadeCodigo);

      return Medicos(
        cod_profissional: medicoData['cod_profissional'] ?? '',
        des_profissional: medicoData['des_profissional'] ?? '',
        celular: medicoData['celular'] ?? '',
        crm: medicoData['crm'] ?? '',
        data_nascimento: medicoData['data_nascimento'] ?? '',
        cpf: medicoData['cpf'] ?? '',
        nomecompleto: medicoData['nomecompleto'] ?? '',
        ativo: medicoData['ativo'] ?? '',
        email: medicoData['email'] ?? '',
        subespecialidade: medicoData['subespecialidade'] ?? '',
        idademin: medicoData['idademin'] ?? '',
        idademax: medicoData['idademax'] ?? '',
        pacientesAtendidos: medicoData['pacientesAtendidos'] ?? '',
        totalDeAtendidos: medicoData['totalDeAtendidos'] ?? '',
        especialidade: especialidade,
      );
    } else {
      throw Exception('Falha ao obter os dados do médico.');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_profissional': cod_profissional,
      'des_profissional': des_profissional,
      'celular': celular,
      'crm': crm,
      'data_nascimento': data_nascimento,
      'cpf': cpf,
      'nomecompleto': nomecompleto,
      'ativo': ativo,
      'email': email,
      'subespecialidade': subespecialidade,
      'idademin': idademin,
      'idademax': idademax,
      'pacientesAtendidos': pacientesAtendidos,
      'totalDeAtendidos': totalDeAtendidos,
      'especialidade': especialidade.toJson(),
    };
  }

  factory Medicos.fromJson(Map<String, dynamic> json) {
    return Medicos(
      cod_profissional: json['cod_profissional'] ?? '',
      des_profissional: json['des_profissional'] ?? '',
      celular: json['celular'] ?? '',
      crm: json['crm'] ?? '',
      data_nascimento: json['data_nascimento'] ?? '',
      cpf: json['cpf'] ?? '',
      nomecompleto: json['nomecompleto'] ?? '',
      ativo: json['ativo'] ?? '',
      email: json['email'] ?? '',
      subespecialidade: json['subespecialidade'] ?? '',
      idademin: json['idademin'] ?? '',
      idademax: json['idademax'] ?? '',
      pacientesAtendidos: json['pacientesAtendidos'] ?? '',
      totalDeAtendidos: json['totalDeAtendidos'] ?? '',
      especialidade: Especialidade.fromJson(json['especialidade'] ?? {}),
    );
  }
}
