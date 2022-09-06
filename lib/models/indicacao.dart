import 'dart:convert';

import 'package:biomaapp/models/convenios.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Indicacao with ChangeNotifier {
  String id_indicacao = '';
  String id_servico = '';
  String descricao = '';
  String status = '';
  String data_criacao = '';
  String hora_criacao = '';
  String autor = '';
  String visivel = '';
  String cod_procedimento = '';
  String des_procedimento = '';
  String cod_convenio = '';
  String des_convenio = '';
  String cod_tratamento = '';
  String des_tratamento = '';
  String cod_especialista = '';
  String des_especialista = '';
  String cod_unidade = '';
  String des_unidade = '';
  String cod_especialidade = '';
  String des_especialidade = '';
  String valor = '';
  String olho = '';
  String quantidade = '';
  String obs = '';
  String data = '';
  String hora = '';

  Indicacao();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Indicacao &&
          runtimeType == other.runtimeType &&
          id_indicacao == other.id_indicacao;

  @override
  int get hashCode => id_indicacao.hashCode;

  @override
  String toString() {
    return descricao;
  }
}
