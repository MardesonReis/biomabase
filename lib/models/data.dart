import 'dart:convert';

import 'package:biomaapp/models/unidade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biomaapp/utils/constants.dart';

class Data with ChangeNotifier {
  final String id_regra;
  final String crm;
  final String valor_sugerido;
  final String orientacoes;
  final String cpf;
  final String cod_profissional;
  final String des_profissional;
  final String cod_especialidade;
  final String des_especialidade;
  final String grupo;
  final String idade_mim;
  final String idade_max;
  final String sub_especialidade;
  final String cod_unidade;
  final String des_unidade;
  final String cod_convenio;
  final String desc_convenio;
  final String cod_procedimentos;
  final String des_procedimentos;
  final String cod_tratamento;
  final String tipo_tratamento;
  final String tabop_quantidade;
  final String valor;
  final String frequencia;

  String get textBusca =>
      des_profissional +
      ' - ' +
      this.des_especialidade +
      ' - ' +
      this.sub_especialidade +
      ' - ' +
      this.grupo +
      ' - ' +
      this.desc_convenio +
      ' - ' +
      this.des_unidade +
      ' - ' +
      this.des_procedimentos;

  Data({
    required this.id_regra,
    required this.valor_sugerido,
    required this.orientacoes,
    required this.crm,
    required this.cpf,
    required this.cod_profissional,
    required this.des_profissional,
    required this.cod_especialidade,
    required this.des_especialidade,
    required this.grupo,
    required this.idade_mim,
    required this.idade_max,
    required this.sub_especialidade,
    required this.cod_unidade,
    required this.des_unidade,
    required this.cod_convenio,
    required this.desc_convenio,
    required this.cod_procedimentos,
    required this.des_procedimentos,
    required this.cod_tratamento,
    required this.tipo_tratamento,
    required this.tabop_quantidade,
    required this.valor,
    required this.frequencia,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Data &&
          runtimeType == other.runtimeType &&
          textBusca == other.textBusca;

  @override
  int get hashCode => textBusca.hashCode;

  @override
  String toString() {
    return textBusca;
  }
}
